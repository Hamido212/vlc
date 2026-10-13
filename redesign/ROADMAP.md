# Roadmap

What the redesign consists of, in the order it is being built. A box is ticked
once the part runs in the Windows build and was looked at there.

## Player

- [x] Windows build in Docker
- [x] Dark and light palette
- [x] Control bar in a single row: play button, thick seek bar, volume cone
- [x] Icons of the redesign in the icon font
- [x] Top bar: logo, menu, library, folder, title, full screen, window buttons
- [x] Video framed between the bars
- [x] Preview of the frame under the pointer on the seek bar
- [x] Tracks panel (video, audio and output device, subtitles) and its two buttons
- [ ] Settings sidebar, opened by the settings button and by "Show Preferences"
  - [x] Panel with its four tabs, delays and speeds
  - [x] Subtitles: delay, font, colors, size, outline, position, default track
  - [x] Audio: delay, default track, equalizer preset, filter switches, pitch
  - [ ] Audio: stereo mode, equalizer bands, settings of each filter
  - [ ] Video: flip, rotate, zoom, crop, aspect ratio, colors
    - [x] Negate Colors: visible activation and clean restoration on D3D11
    - [x] Image Adjust: live brightness slider and clean restoration
    - [x] Pixel crop fields: Top and Left changes and restoration
    - [x] Flip and rotation with hardware decoding, including restoration
    - [ ] Renderer list in the Video tab
      - Opening discovery was tested, but its 20-second shutdown blocked the
        Qt thread and PrintWindow. Keep the UI experiment unapplied until the
        discovery shutdown is fixed; see experiments/renderer-panel.patch.
  - [ ] Playback: speed, sleep timer, what the bar shows
    - [x] The tab as one list, as in the design
    - [x] Speed: slider from 0.25x to 2x
    - [x] Sleep timer: preset times, a typed one, the time left, pause when
          it is over
    - [x] Audio visualizer: Spectrometer and Disable
    - [ ] Reverse: the switch is there, nothing that plays backwards was at
          hand to try it on
    - [ ] "Show Subtitle Timeline on Seekbar" and "Show Statistics": what they
          switch on does not exist yet
  - [ ] Presets for a show
- [x] Queue panel
  - [x] The list and its head: how much there is, sort, repeat, shuffle, remove
  - [x] Play a row with a double click, move it by its handle
  - [x] Add files from the file dialog
  - [x] The button, the "Play Queue" shortcut and the menu entry all show it,
        and it stays while another row is played
- [x] Volume level next to the cone while it changes
- [ ] Bookmarks and chapters panels, subtitle timeline
- [ ] Full screen: both bars on hover, an option to hide the interface
- [ ] Resume prompt next to the playback controls
- [ ] Menus: the menu of the top bar, the right-click menu, two-tone icons
- [ ] Music: cover view, waveform seek bar

## Library

- [ ] Sidebar over the video: home, videos, music, streams, playlists, pinned
- [ ] Pages: toolbar with address line, sorting, view modes and search
- [ ] Context menus of files, folders and playlists
- [ ] Mini player

## Dialogs

- [ ] Open network stream, new playlist
- [ ] Add subtitles to a file, a folder or a playlist
- [ ] Keyboard shortcuts
- [ ] Settings with its categories
- [ ] Customize mode: move the controls around, profiles
- [ ] Onboarding

## Loose ends

- [ ] Inter as the font of the interface
- [ ] The build does not quit within a few seconds and can leave a process behind
- [ ] "External Tracks" of the subtitles tab has no list of its own
