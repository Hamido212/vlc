# VLC redesign

This fork implements the VLC interface redesign by
[Juxtopposed](https://juxtopposed.com) on top of VLC 4 (the Qt/QML interface in
`modules/gui/qt`).

- Video: [I Redesigned VLC After 25 Years](https://www.youtube.com/watch?v=ERFeOgqk324)
- Design file: [VLC Redesign on Figma Community](https://www.figma.com/community/file/1691465999134370980)

The design is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
by Juxtopposed. VLC itself stays under its own licenses, see `COPYING`.

The SVG export of the Figma icon library in `redesign/icons/figma` and the
list of paint styles the palette was checked against come from
[Olmo Gutierrez' implementation](https://github.com/Olmo-Gutierrez/VLC-juxtopposed)
of the same redesign, as does the idea for the frame around the video.

This is an unofficial project, it is not affiliated with VideoLAN.

## Building on Windows

Docker Desktop is the only requirement. The build runs in the same image
VideoLAN's CI uses and reuses their prebuilt third-party libraries.

```powershell
.\redesign\docker-build.ps1        # everything, takes a while the first time
.\redesign\docker-build.ps1 qt     # after changing only modules/gui/qt
.\build-win64\vlc.exe
```

The build keeps its settings in `build-win64\portable`, delete that folder to
start over with the defaults.

## Building on Linux

On Linux itself this is VLC's usual build (`./bootstrap`, `./configure`,
`make`, then `./vlc` from the build directory), with Qt 6 and its SVG image
plugin installed.

From Windows, the same can be done in VideoLAN's Debian image, to see that a
change still compiles and runs there:

```powershell
.\redesign\docker-build-linux.ps1          # everything, takes a while the first time
.\redesign\docker-build-linux.ps1 qt       # after changing only modules/gui/qt
.\redesign\docker-build-linux.ps1 shot -Media clip-m.mp4
```

`shot` starts the player on a screen that is only in memory, plays the file
from `redesign\tools\Videos` and puts a picture of the screen and the log
into `build-linux\`. That image has no SVG plugin for Qt, so the volume cone
and the cover placeholder are missing in its pictures. The build stays in a
Docker volume and is of no use outside of the image.

## Icons

VLC draws its icons with a font, `modules/gui/qt/pixmaps/VLCIcons.ttf`. The
glyphs listed in `VLCIcons.json` with a path in `icons/redesign/` are made
from the Figma icons:

```powershell
.\redesign\icons\update.ps1
```
