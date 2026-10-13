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

## Renderer discovery experiment (2026-10-13)

The UI experiment added Render/Local, model display/checked roles and a scan
button. The Windows build showed Local and the active countdown, and the log
confirmed UPnP and mDNS discovery startup. No external renderer was selected.

At the end of the 20-second scan, the Qt window stopped responding and
`PrintWindow` blocked. `RendererManager::StopScan()` synchronously releases
discovery modules on the Qt thread. This needs further shutdown investigation
before automatic discovery is enabled by the panel. The experiment is saved
in `experiments/renderer-panel.patch` and is not applied to the shipped UI.

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
