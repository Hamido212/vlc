# Windows build verification

Checks use `redesign/tools/shot.ps1`: window messages, `PrintWindow(..., 2)`,
1440x1080, and `SetWindowPos` without activation or a stacking-order change.
The local color-bar clip is `redesign/tools/Videos/clip-m.mp4`.

## Video filters (2026-10-13)

Hardware decoding and output: D3D11.

- Before the fix, Negate Colors produced corrupted color bars; switching it
  off left the video corrupted despite the switch showing OFF.
- D3D11's `update_format` selected NV12 storage for planar YV12 input but
  reported success without a converter. Rejecting that unsupported direct
  upload lets the core append the existing CPU-to-D3D11 converter.
- A filter can also change the display's source format. When the filter chain
  returns to its original format, the core now restores the display and the
  private picture pool.
- Seen after the fix: red/green/yellow/blue bars become
  cyan/magenta/blue/yellow with Negate Colors ON, then return to their original
  colors with it OFF. `test-video-filters.ps1` checks all four bars.
- Seen: Image Adjust ON, Brightness 0.49 visibly darkens the video. Returning
  to 1.00 and switching the filter OFF restores the original colors.
- Seen: Crop Top 120px and Left 160px change the displayed video. Both fields
  and the image return to their original state after entering 0.

Other filter switches, HDR output, remote resolution selection, and the Right
and Bottom crop fields have not been checked at the image level yet.

## Flip and rotation (2026-10-13)

- The transform filter changes orientation without changing picture storage.
  The core now asks capable displays to accept that orientation rather than
  trying to convert it back to the original orientation.
- The filter retains its input hardware video context for its output, and
  releases the retained reference when it closes. D3D11 rejects opaque input
  without a compatible context.
- Recreating D3D11 textures for a pure orientation change caused a driver
  access violation in the first experiment. The final path updates only the
  quad transform, under the D3D11 device lock. The existing core restoration
  path resets the orientation after removing the filter.
- Filter proxy variables persist across restarts. Changing only the saved
  `transform-type` left subsequent selections on the first orientation. The
  settings panel now updates both the saved and live option.
- Seen and checked on D3D11: horizontal and vertical flips, consecutive
  90/180/270 degree rotations, and returning to 0/None. The vertical flip moves
  the clip's embedded timestamp to the bottom left; 90/270 use portrait
  placement. `test-transform.ps1` verifies these states from the window images.
- Software decoding, other output backends, HDR transforms, and combined
  flip/rotation selections have not been verified yet.

## Renderer list (2026-10-13)

"Render" of the Video tab lists what the renderer manager of the player
finds, with "Local" for none. The scan starts when the tab is shown and ends
by itself after 20 seconds.

- A first attempt stood still at the end of the scan: closing the discoveries
  waits for their threads, UPnP's for seconds, and that was done on the
  thread of the interface. They are closed on a thread of their own now.
- Seen: "Render" says "Local"; the log has the start of the UPnP and the mDNS
  discovery. 24 seconds later the window still answers: a list opens, the
  tab changes.
- Not tried: a device in the list and playing on it, there was none in reach.

## Playback tab (2026-10-13)

Reference: Figma file `kJ3O3At8xC5cqxEwD2LD1n`, node `2238:9432`, kept as
`design/playback-reference.tsx`. The tab is one list without group titles, as
in the design: Reverse, Sleep Timer, Audio Visualizer, Speed.

- Seen: the list, with the speed slider from 0.25 to 2, its eight marks and
  their labels.
- Seen: the slider at 2, at 0.5 and back at 1. The box says "0.5x" and "1x",
  the log `setRate 2.000000`, `setRate 0.500000` and `setRate 1.000000`.
- Seen: the list of the timer. "15 min" puts the time left in the field
  ("00:14:58"), "Off" ends it. "Custom" adds a Duration field; "0:05" typed
  there starts five seconds. With the panel closed the video is paused when
  they are over, and the tab is back at "Off" without the field.
  `test-sleep-timer.ps1` checks that the timestamp in the video stands still.
- The timer is the player controller's and has a deadline on the monotonic
  clock, so it does not depend on the panel, the speed or what plays.
  Something that cannot be paused is stopped instead; that was not tried.
- Seen: Spectrometer draws for the generated tone, Disable takes it away
  again. The dummy audio output keeps the test silent.
- Reverse is disabled unless what plays can be rewound. The test clip cannot,
  so playing backwards was not tried.
- Not built: "Show Subtitle Timeline on Seekbar" and "Show Statistics" of the
  design. There is no subtitle timeline and no statistics display to switch
  on yet.

## Volume level (2026-10-13)

The box of the design ("audio value", 121x37) over the cone, in place of the
tooltip of the slider.

- Seen: a click on the cone changes the volume and the box says "38 %", it is
  gone three seconds later; a click further right says "102 %". Run with
  `--no-audio`: nothing is heard, the volume is still that of the output.
- The dummy audio output takes no volume, so it cannot be used for this.
- Not seen: the box while the pointer only rests on the cone. A pointer move
  posted to the window does not keep Qt's hover state, the same as for the
  seek preview; this needs a look with the real pointer.

## Queue panel (2026-10-13)

Reference: Figma variant `491:1781`, noted in `design/queue-panel.md`. Four
clips in the queue, panel opened with the queue button of the control bar.

- Seen: the tab, "4 items - 10m", the five buttons and the rows with handle,
  name and duration; what plays has its name in the accent.
- Seen: a click picks a row and "remove" takes it out ("3 items - 7m").
- Seen: a double click plays the row, the panel stays and the accent goes to
  that row. The panel is the player view's, not the button's: the buttons of
  the bar are made anew when the video goes and comes back.
- Seen: Ctrl+L opens and closes the panel; the button opens it, closes it
  with a second press and it closes with a click next to it. The menu entry
  sets the same property as the shortcut and was not clicked.
- Seen: dragging a handle shows a line in the gap the row would go to; let go
  of at the top and between two rows, the row is there afterwards.
- Seen: shuffle and repeat switch to the accent, repeat goes on to "one".
- Seen: the list of what to sort by; "Title" sorts, "Title" again turns the
  order around.
- Seen: "add" closes the panel and shows the file dialog of the system; with
  a clip named in it the queue is one longer. The test answers the dialog
  with messages (`f:` step of `shot.ps1`).
- A queue that is open in the library does not open the panel when a video
  starts; the first press or shortcut then does. Not tried.
- The tabs for bookmarks and chapters of the design are not there yet, they
  come with their own item of the roadmap.

## Preferences startup (fork PR #6, 2026-10-14)

- Branch: `adopt-dsojevic-preferences`. The Windows Qt build completed with
  six jobs and exit code 0. No Linux build was started.
- Removed the five unstyled `QtQuick.Controls` imports. Remaining Controls
  imports and resource registrations under `modules/gui/qt` predate this PR.
- The first attempt did not create a window within 20 seconds. The one
  retry exposed a gray QWindow and the assertion: the log reported
  `Popup is not a type` in `Widgets/ComboBoxExt.qml`. The dev processes were
  stopped immediately. Both used combo boxes now have their own template
  delegates and popups, without that dependency.
- Seen after rebuilding: the player at 1440x1080, General and Controls in
  the separate preferences window, and the Keyboard Shortcuts popup.
  `preferences-main.png`, `preferences-controls-replaced.png`,
  `preferences-controls-page.png` and `preferences-shortcuts-startup.png`
  were captured with `shot.ps1` and inspected. Preferences were 1348x1119
  at the current 1.25 interface scale. This is startup verification, not
  yet a comparison of every category with Figma.
- Search placeholders, text fields, selection fields and toggle states
  are visible. The imported SVG icons are missing; the layout still differs
  from Figma. Hover, tooltips and shortcut editing were not tested here.
- `shot.ps1` can select the second VLC window with `n:` and stops its dev
  process when the log reports a QML loading error. A gray QWindow alone
  no longer counts as a successful startup in that test.

## Preferences and shortcuts comparison (fork PR #6, 2026-10-14)

Reference: the 19 Settings frames and Keyboard Shortcuts frame `2437:14832`
in the local Figma export, `tokens.json` and the local settings reference PNG.
[Preferences reference audit](design/preferences-audit.md) records the frame
IDs, exact labels, geometry, native option sources and unresolved mappings.
The imported dsojevic interface remains the implementation source; Figma is
the design reference. No Figma API was used.

- Branch: `adopt-dsojevic-preferences`, implementation commit `af218592e1`.
  The final Windows Qt build completed with six jobs and exit code 0.
  No Linux build was started.
- All captures and interactions used `tools/shot.ps1`: `PostMessage` for
  clicks, keys and scrolling; `PrintWindow(hwnd, dc, 2)` for window images;
  `SetWindowPos` without activation or a change in stacking order for size.
  No real mouse, keyboard or desktop screenshot was used.
- Seen: the player at 1440x1080; preferences at 1310x1081, corresponding to
  the authored 1048x865 frame at the current 1.25 interface scale; Keyboard
  Shortcuts at 1310x1000, corresponding to 1048x800 at that scale.
- Seen and compared: General, Interface, Privacy, Controls, Playback,
  Video, Audio, Subtitles, Library, Network, Performance, Recording and
  Extensions, at the top and after scrolling to the bottom. The separate
  window shows Search, the App/Media/System navigation groups, category
  titles and Close. The retained groups and rows follow the local frames.
- Seen and compared: the expanded Advanced Options for General, Interface,
  Playback, Video, Audio, Subtitles and Performance. The other frames show
  the affordance without additional referenced rows; no rows were invented.
- Seen: Dark and Light palettes, a purple accent swatch, and the return to
  Dark with the default accent. Text, fields, toggle states, slider marks,
  color chips and the generated category icons are visible.
- Seen: searching preferences for gamma leaves its slider as the result;
  searching Keyboard Shortcuts for fullscreen leaves its three matching
  Basic actions. These checks are recorded in `search.png` and
  `shortcuts-search.png`; other search terms and selector combinations
  were not tried.
- In this Windows build, Check for updates automatically is visible. The
  four General system-log rows are absent and their empty Developer Options
  heading is hidden: Write to the system log, Include debug messages in the
  system log, System log identity and System log facility. These are native
  Syslog options whose module is conditional, rather than missing catalog
  mappings. Other platform and plugin availability must not be inferred from
  an option's presence in the source alone.

Images are in [screenshots/preferences](screenshots/preferences/):
`general.png`, `interface.png`, `privacy.png`, `controls.png`, `playback.png`,
`video.png`, `audio.png`, `subtitles.png`, `library.png`, `network.png`,
`performance.png`, `recording.png` and `extensions.png`, with corresponding
`-bottom.png` captures. The seven expanded pages have `-advanced.png`
captures. `light.png` and `accent.png` record the palette checks.

Keyboard Shortcuts:

- Seen: the nine referenced Basic and Playback rows, Search, the All Fields
  selector, local/global shortcut columns, Cancel and Save.
- Seen: changing the fullscreen shortcut from F to F12, saving, restarting
  VLC and seeing F12 again. F was then restored and the editor reopened to
  confirm it.
- Seen: assigning N to fullscreen opens the conflict dialog. Cancel keeps
  the existing F and N assignments. The Yes/reassignment path was not tried.
- Images: `shortcuts.png`, `shortcuts-persisted.png`,
  `shortcuts-restored.png`, `shortcuts-conflict.png` and
  `shortcuts-conflict-cancel.png`. Editing and persistence were checked;
  triggering the player actions or registering global shortcuts was not.

Equalizer:

- The user approved VLC's native band representation inside Figma's opaque
  784x489 equalizer instance. This is a presentation exception; the XML does
  not establish its internal band layout.
- Seen: ten bands (60, 170, 310 and 600 Hz; 1, 3, 6, 12, 14 and 16 kHz),
  a separate Preamp, gain readouts and the Classical preset. The native
  range is -20 to +20 dB with 0.1 dB steps.
- Seen: the 60 Hz band at 5.2 dB and Preamp at 5.1 dB; both remained after
  restarting VLC and the other bands retained their values. The log reports
  an equalizer loaded at 48 kHz with ten bands. No audible comparison or
  live effect on a playing output was checked.
- Seen: Flat restores all bands to 0.0 dB and Preamp to 12.0 dB. The
  equalizer was switched off again. The alternative ISO frequencies were
  not tried.
- Images: `equalizer-expanded.png`, `equalizer-preset.png`,
  `equalizer-edited.png`, `equalizer-persisted.png`, `equalizer-flat.png`
  and `equalizer-restored.png`.

The following Figma rows remain omitted. These are unresolved mappings or
actions, distinct from native options hidden by the running build:

| Category | Missing Figma rows | Reason |
|---|---|---|
| General | Interface language; Developer mode; Show minor warnings; Additional command line options; Open configurations folder; Reset all settings | No current language/minor-warning/arbitrary command-line config. `qt-verbose` controls Qt logging, not a developer mode. Folder opening and global reset are not wired actions. |
| Interface | Use a custom skin; Remember window size and position; Auto-hide the controls; Hide after; Popup duration; Show cover art in the window when playing audio; Fullscreen controls sensitivity | Skin selection requires an interface restart, rather than a boolean. Geometry/autohide/duration option names have no current definitions. `qt-bgcone` controls an idle logo. Low/Medium/High sensitivity values are unspecified. |
| Privacy | Never remember items matching; Clear history now; second Last.fm username | The recent-item filter is obsolete. The existing media-library clear-history action is not wired. The duplicate label is ambiguous and the user approved omitting it. |
| Controls | Double click on the video; Reverse scroll direction in Mouse and Remotes; Web remote control | No persistent double-click selector or reverse-scroll config. Enabling the HTTP interface and its lifecycle are not wired. |
| Playback | Show thumbnail while scrubbing; Time-shift buffer size | No persistent thumbnail option. The authored Medium preset does not specify a value for the native byte-count option. |
| Video | Reset picture; Size; Monitor pixel aspect ratio; Time-shift buffer size | Compound picture reset is not wired. Snapshot width/height exist but the combined size presets are unspecified. No persistent monitor-pixel-aspect option; Medium time-shift size remains unspecified. |
| Audio | Output device; Startup volume; Night mode; Spatial audio; Spatial audio mode; Pitch shift; Resampling quality; Visualization size | No generic device model. Startup volume combines unverified remember/scalar behavior. No defined night-mode filter profile. Spatial audio is a renderer/converter and the headphone option is obsolete. Pitch gain alone would not enable its filter. Balanced resampling and Match window size presets are unspecified. |
| Subtitles | Size values; Shadow; Shadow distance; Background; Vertical position; Show feedback for; Ignore styling in ASS and SSA subtitles; Visualization size | Units and toggle/restore behavior are unspecified. Small, None, Bottom and Match window lack verified preset mappings. No persistent OSD feedback-duration option; `subsdec-formatted` controls USF rather than ASS/SSA styling. |
| Library | Fetch titles and artwork | The native network-metadata boolean does not establish the authored multi-level policy. |
| Network | Buffering; Cipher preference | Individual cache values and a raw GnuTLS priority string exist; Normal and Balanced preset mappings are unspecified. |
| Performance | Hardware-accelerated decoding; Give VLC real-time priority; Process priority; Rescan plugins; Encoder | The imported hardware option is obsolete and the current boolean/device selector does not establish Automatic semantics. Windows high priority is above-normal/high, not real-time. Numeric priority is absent. Plugin-cache reset is startup-only and the live action is not wired. Encoder is obsolete. |
| Recording | Discover cast devices | RendererManager has a scan action, not a persistent discovery boolean. |
| Extensions | Extension list; Search; Find more extensions; Add; Remove | The imported preference adapter has no add-on management model or actions. |

Known presentation differences remain: native enums are retained for playback
position and screensaver behavior; subtitle Font size uses a native percentage
and Outline thickness uses native choices; Aspect ratio, Crop, Zoom and Decoder use raw native
values instead of unverified authored presets. Cast quality is present with
VLC's High/Medium/Low/Low CPU choices; the Figma Automatic example is not a
native choice. Inter font matching remains open. The exported video icon is
a screen outline; the reference PNG's clapperboard detail remains open.

The user approved the inherited nine accent swatch colors, correcting
"track changew" to "track changes", omitting the second Last.fm username,
and the native equalizer bands. These exceptions are not claimed as exact
Figma paint or component matches.

One long run through advanced pages froze. Its dev process was stopped.
The controls now use inline template tooltips, and shorter repeat runs
completed, but the cause of that freeze has not been proven. After changing
the Qt DLL, the initial launch timed out in two equalizer-build tests; exactly
one retry each loaded the interface. The final test logs had no QML loading
errors. The dev build can still require forced termination after closing.

Not checked: hover, tooltips, clearing shortcuts on hover, global shortcut
registration, conflict reassignment with Yes, other search combinations, external
services, audible filter effects or persistence of most individual settings.
The captures verify the visible pages and the specified edits, not every
setting's effect or complete Figma fidelity.

## Build and test environment

- Use `make` for changes to `src/` or the D3D11 output module; use `qt` for
  interface-only changes. Keep six jobs.
- Windows can keep build binaries locked even when a process reports that it
  has exited and `taskkill` reports no running instance. The package-copy
  fallback now moves locked EXE/DLL files aside as well as the Qt plugin.
  Backups remain beside the replaced files with a timestamp and `.old` suffix.
- Disable Qt video autoresizing during input tests. Crop changes can otherwise
  resize the window again and invalidate subsequent click coordinates.
- Wait after posted Backspace/Delete messages before posting replacement
  text: Qt's translated character messages can otherwise erase the new text.
- The dev build still often needs forced termination after closing its window.
  Existing bookmark-model and SpacerWidget focus warnings remain in the log.
