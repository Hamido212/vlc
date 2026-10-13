# Verify that the sleep timer survives panel closure and stops video progress.
param([string]$Media = "$PSScriptRoot/Videos/clip-m.mp4")

$ErrorActionPreference = 'Stop'
$first = Join-Path $PSScriptRoot 'sleep-paused.png'
$later = Join-Path $PSScriptRoot 'sleep-paused-later.png'
& "$PSScriptRoot/shot.ps1" -Media $Media -Out "$PSScriptRoot/sleep-finished.png" `
    -VlcArgs '--no-audio', '--repeat' `
    -Click "1325,1038;1270,247;1270,538;1300,313;e:0:05;1325,1038;p:7000;s:$first;p:2500;s:$later;1325,1038"

$before = [Drawing.Bitmap]::new($first)
$after = [Drawing.Bitmap]::new($later)
try {
    # The timestamp is part of the video, not a UI clock. It must stay still.
    for ($x = 24; $x -lt 134; ++$x) {
        for ($y = 135; $y -lt 176; ++$y) {
            if ($before.GetPixel($x, $y).ToArgb() -ne $after.GetPixel($x, $y).ToArgb()) {
                throw 'Video continued advancing after sleep timer expiry.'
            }
        }
    }
    'PASS: the sleep timer pauses playback after the panel closes.'
} finally {
    $before.Dispose()
    $after.Dispose()
}
