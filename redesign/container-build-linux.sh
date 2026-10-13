#!/bin/sh
# Runs inside VideoLAN's Debian build image, started by docker-build-linux.ps1.
#
#   /host/src   the checkout on the Windows side (read-only)
#   /host/out   where the picture and the log of a test run end up
#   /work       Docker volume holding the source copy and the build tree
#
# Usage: container-build-linux.sh [full|make|qt|shot]
#   full   bootstrap, configure and build everything (default)
#   make   build what changed, needs a configured tree
#   qt     only rebuild the Qt interface plugin
#   shot   do not build: start the player on a screen that is only in
#          memory, take a picture of it and say what its log has on the
#          interface

set -e

MODE=${1:-full}
SRC=/work/src
STAGE=/work/stage
BUILD=/work/build

: "${JOBS:=6}"

mkdir -p "$SRC" "$BUILD"

if [ "$MODE" != "shot" ]; then
    # The same copy as in container-build.sh: only files whose content
    # changed are brought over, so that make sees what is new.
    rm -rf "$STAGE"
    mkdir -p "$STAGE"
    (cd /host/src && tar cf - --exclude=./.git --exclude=./build-win64 --exclude=./build-linux .) | (cd "$STAGE" && tar xf -)
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

    if [ "$(cat "$SRC/src/revision.txt" 2>/dev/null)" != "${VLC_REVISION:-unknown}" ]; then
        echo "${VLC_REVISION:-unknown}" > "$SRC/src/revision.txt"
    fi
fi

cd "$BUILD"

if [ "$MODE" != "full" ] && [ ! -f Makefile ]; then
    echo "No configured build tree yet, doing a full build"
    MODE=full
fi

case "$MODE" in
    full)
        (cd "$SRC" && ./bootstrap)
        # The libraries are those of the image, as in the "debian" job of
        # extras/ci/gitlab-ci.yml.
        "$SRC"/configure
        make -j"$JOBS"
        ;;
    make)
        make -j"$JOBS"
        ;;
    qt)
        make -C modules/gui/qt -j"$JOBS"
        ;;
    shot)
        # No screen in a container: X draws into memory and keeps that in a
        # file, OpenGL is done by the processor.
        export LIBGL_ALWAYS_SOFTWARE=1
        export HOME=/work/home
        mkdir -p "$HOME" /host/out
        rm -rf /work/fb /host/out/vlc-linux.log
        mkdir -p /work/fb

        # Nothing places the window there: the screen is large enough to
        # hold it wherever it comes up.
        Xvfb :99 -screen 0 2560x1600x24 -fbdir /work/fb >/dev/null 2>&1 &
        XVFB=$!
        sleep 2

        DISPLAY=:99 "$BUILD"/vlc -vv --no-audio --no-qt-privacy-ask --file-logging \
            --logfile=/host/out/vlc-linux.log ${VLC_MEDIA:+"$VLC_MEDIA"} >/dev/null 2>&1 &
        VLC=$!
        sleep "${VLC_WAIT:-25}"

        python3 /host/src/redesign/tools/xwd-to-png.py /work/fb/Xvfb_screen0 /host/out/vlc-linux.png

        kill $VLC 2>/dev/null || true
        sleep 2
        kill -9 $VLC 2>/dev/null || true
        kill $XVFB 2>/dev/null || true

        grep -E "qt (warning|error|critical)|cannot load|no suitable interface|using interface module|compositor" \
            /host/out/vlc-linux.log | cut -c1-220 | head -30 || true
        ;;
esac
