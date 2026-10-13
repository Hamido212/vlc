#!/bin/sh
# Runs inside VideoLAN's win64 build image, started by docker-build.ps1.
#
#   /host/src   the checkout on the Windows side (read-only)
#   /host/out   where the runnable VLC tree ends up
#   /work       Docker volume holding the source copy and the build tree
#
# Usage: container-build.sh [full|make|qt]
#   full  bootstrap, configure and build everything (default)
#   make  build what changed and package again, needs a configured tree
#   qt    only rebuild the Qt interface plugin and drop it into the package

set -e

MODE=${1:-full}
SRC=/work/src
STAGE=/work/stage
BUILD=/work/build
PKG=$BUILD/vlc-redesign
STRIP="x86_64-w64-mingw32-strip --strip-debug --preserve-dates"
: "${JOBS:=6}"
export JOBS

mkdir -p "$SRC" "$BUILD"

# Compiling straight from the Windows bind mount is slow, so build from a copy.
# Nothing is deleted on the copy: bootstrap leaves its generated files there.
#
# Only files whose content changed are brought over, and they get the current
# time: a file edited on the host while an earlier build was running is older
# than what that build made out of its previous content, make would skip it.
rm -rf "$STAGE"
mkdir -p "$STAGE"
(cd /host/src && tar cf - --exclude=./.git --exclude=./build-win64 .) | (cd "$STAGE" && tar xf -)
export SRC STAGE
(cd "$STAGE" && find . -type f -print0) | xargs -0 -n 256 sh -c '
    for f; do
        if ! cmp -s "$STAGE/$f" "$SRC/$f"; then
            mkdir -p "$SRC/$(dirname "$f")"
            cp "$STAGE/$f" "$SRC/$f"
            echo "updated $f"
        fi
    done' sh
rm -rf "$STAGE"

# The copy has no .git, so the build cannot ask git for the revision and falls
# back to this file. Only touch it when the revision changed, it is a
# dependency of libvlccore.
if [ "$(cat "$SRC/src/revision.txt" 2>/dev/null)" != "${VLC_REVISION:-unknown}" ]; then
    echo "${VLC_REVISION:-unknown}" > "$SRC/src/revision.txt"
fi

cd "$BUILD"

if [ "$MODE" != "full" ] && [ ! -f win64/Makefile ]; then
    echo "No configured build tree yet, doing a full build"
    MODE=full
fi

case "$MODE" in
full)
    if [ -n "$VLC_CONTRIB_SHA" ]; then
        export VLC_PREBUILT_CONTRIBS_URL="https://artifacts.videolan.org/vlc/win64/vlc-contrib-x86_64-w64-mingw32-${VLC_CONTRIB_SHA}.tar.zst"
    fi
    "$SRC"/extras/package/win32/build.sh -a x86_64 -p -o "$PKG"
    ;;
make)
    export PATH="$BUILD/extras/tools/build/bin:$PATH"
    make -C win64 -j"$JOBS"
    make -C win64 package-win-common
    ;;
qt)
    export PATH="$BUILD/extras/tools/build/bin:$PATH"
    make -C win64/modules/gui/qt -j"$JOBS"
    cp win64/modules/gui/qt/.libs/libqt_plugin.dll "$PKG/plugins/gui/"
    ;;
esac

# The debug info makes the tree several times bigger than it needs to be on
# the Windows side.
NEWER=
if [ -f "$PKG/.stripped" ]; then
    NEWER="-newer $PKG/.stripped"
fi
find "$PKG" -type f \( -name '*.dll' -o -name '*.exe' \) $NEWER -print0 | xargs -0 -r -n 32 $STRIP
touch "$PKG/.stripped"

# With a "portable" directory next to vlc.exe, VLC keeps its settings there
# instead of in the user's profile.
mkdir -p /host/out/portable

# A VLC that is still running, or stuck while quitting, keeps its plugins
# open. Windows does not let them be overwritten then, but they can be moved
# out of the way.
if ! cp -ru "$PKG"/. /host/out/; then
    # Core builds also replace vlc.exe and libvlccore.dll. Retry changed
    # binaries individually, moving only files Windows still keeps locked.
    export PKG
    find "$PKG" -type f \( -name '*.dll' -o -name '*.exe' \) -print0 |
        xargs -0 -r -n 64 sh -c '
            for file; do
                relative=${file#"$PKG"/}
                target=/host/out/$relative
                if ! cp -u "$file" "$target"; then
                    mv "$target" "$target.$(date +%s).old" || exit 1
                    cp "$file" "$target" || exit 1
                fi
            done' sh
    cp -ru "$PKG"/. /host/out/
fi
