"""Packs the Windows build of the redesign into a zip to hand out: without
the settings of whoever built it, without what a build left behind.
python -I package_release.py <build-win64> <out.zip> <name of the folder in the zip>"""
import sys
import zipfile
from pathlib import Path

build, out, top = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]

NOTE = """VLC redesign, preview build (unofficial)
========================================

This is VLC 4 with the interface redesign by Juxtopposed built into it.
It is not made by VideoLAN and it is not an official VLC.

  Source and roadmap:  https://github.com/Hamido212/vlc
  The design:          https://www.figma.com/community/file/1691465999134370980

Start vlc.exe. Nothing is installed: the settings are kept in the folder
"portable" next to it, a VLC that is installed is left alone. To get rid of
it, delete this folder.

Know before you use it:

- It is an experiment. The code is written by AI assistants and tried out by
  hand, nobody has reviewed it the way VideoLAN reviews VLC.
- When its window is closed, vlc.exe can stay behind as a process. Look in
  the Task Manager if it does not start again or the folder cannot be deleted.
- Windows may warn about it: the build is not signed.
- English only, 64-bit Windows only.

VLC is free software under the GPL, see COPYING.txt. The source this build
was made from is the repository above, at the tag of the release.
"""


def wanted(path):
    relative = path.relative_to(build)
    if relative.parts[0] in ("portable", "portable.keep", "sdk"):
        return False
    return not (path.name.endswith(".old") or path.name == ".stripped")


files = sorted(path for path in build.rglob("*") if path.is_file() and wanted(path))
size = 0

with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
    archive.writestr(f"{top}/README-REDESIGN.txt", NOTE.replace("\n", "\r\n"))
    # With this folder there, VLC keeps its settings in it.
    archive.writestr(f"{top}/portable/", "")
    for path in files:
        archive.write(path, f"{top}/{path.relative_to(build).as_posix()}")
        size += path.stat().st_size

print(f"{len(files)} files, {size / 1e6:.0f} MB, zip {out.stat().st_size / 1e6:.0f} MB")
