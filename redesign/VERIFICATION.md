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
