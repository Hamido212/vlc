# Windows player checks

`shot.ps1` starts this checkout's `build-win64/vlc.exe`, sets its window to
1440x1080 twice (before and after video startup), posts input to that window,
and captures it with `PrintWindow(..., 2)`. It never moves the real pointer or
captures the desktop. The launch uses the build directory as its working
directory and shows the Qt window without activation.
Qt video autoresizing is disabled for stable coordinates while changing crop.

```powershell
.\redesign\tools\shot.ps1 -Click '1325,1038;1105,105' -Out .\video.png
```

Steps in `-Click` are separated by semicolons:

- `x,y`: click at a position in the captured window.
- `w:x,y,n`: scroll down by n notches; negative n scrolls up.
- `t:text`: type into the focused field.
- `e:text`: replace the focused field's text and press Enter.
- `k:code`: post a virtual key, for example 13 for Enter.
- `p:ms`: wait for a player event or a filter change.
- `s:path`: save an intermediate window image.

Use `-KeepOpen` to keep a test window, then `-VlcProcessId <id> -Wait 0`
to continue using it. The script only closes processes from this checkout.
It removes the portable play-queue recovery prompt before a fresh launch.

The recovered test clip and subtitle are in `Videos/clip-m.mp4` and
`Videos/clip-m.srt`. The video is a local fixture and is ignored by Git.
Supply `-Media` to use another clip. Images and logs in this directory are
also ignored.

`test-video-filters.ps1` checks Negate Colors on the red/green/yellow/blue test
clip. It compares broad areas of the video to allow for the clip's moving
graphics, while detecting both missing activation and failure to restore the
original colors. Run with the default dark palette and no other video filters.
Inspect its three window images as well as the numeric result.

`test-transform.ps1` checks consecutive horizontal/vertical flips, 90/180/270
degree rotations, and restoration to 0/None. It checks bar colors, portrait
placement, and the timestamp's position; inspect its images as well.

`test-sleep-timer.ps1` sets a five-second timer, closes the settings panel,
and checks that the video's embedded timestamp stops advancing after expiry.
Inspect `sleep-finished.png` to verify that the timer returned to Off.

For audio-only visualizer checks, run `create-test-audio.ps1` and supply
`Videos/test-tone.wav` as `-Media`, with `-VlcArgs '--audio','--aout=dummy','--repeat'`.
The dummy output keeps the test silent while the visualizer receives samples.

Steps of `-Click` beyond a click: `c:x,y` is a double click, `d:x,y,x2,y2`
presses, drags and releases (with `,1` at the end a picture is saved before
the release). Several files in the queue: give the others in `-VlcArgs`.
`m:17,76` is Ctrl+L (a key with a modifier held, set for VLC's thread only),
`f:path` names a file in the file dialog VLC shows and accepts it.
