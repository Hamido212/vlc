# VLC redesign

This fork implements the VLC interface redesign by
[Juxtopposed](https://juxtopposed.com) on top of VLC 4 (the Qt/QML interface in
`modules/gui/qt`).

- Video: [I Redesigned VLC After 25 Years](https://www.youtube.com/watch?v=ERFeOgqk324)
- Design file: [VLC Redesign on Figma Community](https://www.figma.com/community/file/1691465999134370980)

The design is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
by Juxtopposed. VLC itself stays under its own licenses, see `COPYING`.

This is an unofficial project, it is not affiliated with VideoLAN.

## Building on Windows

Docker Desktop is the only requirement. The build runs in the same image
VideoLAN's CI uses and reuses their prebuilt third-party libraries.

```powershell
.\redesign\docker-build.ps1        # everything, takes a while the first time
.\redesign\docker-build.ps1 qt     # after changing only modules/gui/qt
.\build-win64\vlc.exe
```
