# Check consecutive transform changes and restoration on the color-bar clip.
param([string]$Media = "$PSScriptRoot/Videos/clip-m.mp4")

$ErrorActionPreference = 'Stop'
$steps = @('1325,1038', '1105,105', '1270,344', '1250,395', '1000,280')
$steps += "s:$PSScriptRoot/transform-none.png"
$steps += @('1156,280', "s:$PSScriptRoot/transform-horizontal.png")
$steps += @('1300,280', "s:$PSScriptRoot/transform-vertical.png", '1000,280')
$steps += @('1270,344', '1250,435', "s:$PSScriptRoot/transform-90.png")
$steps += @('1270,344', '1250,475', "s:$PSScriptRoot/transform-180.png")
$steps += @('1270,344', '1250,515', "s:$PSScriptRoot/transform-270.png")
$steps += @('1270,344', '1250,395')
& "$PSScriptRoot/shot.ps1" -Media $Media -Out "$PSScriptRoot/transform-restored.png" `
    -VlcArgs '--no-audio', '--repeat' -Click ($steps -join ';')

function CheckColor([string]$name, [int]$x, [int]$y, [int[]]$expected,
                    [int]$radiusX = 30, [int]$radiusY = 45) {
    $bitmap = [System.Drawing.Bitmap]::new("$PSScriptRoot/transform-$name.png")
    try {
        $channels = @(@(), @(), @())
        for ($px = $x - $radiusX; $px -le $x + $radiusX; $px += 3) {
            for ($py = $y - $radiusY; $py -le $y + $radiusY; $py += 3) {
                $color = $bitmap.GetPixel($px, $py)
                $channels[0] += $color.R
                $channels[1] += $color.G
                $channels[2] += $color.B
            }
        }
        for ($channel = 0; $channel -lt 3; ++$channel) {
            # Ignore the clip's moving diagonal line by using the median.
            $sorted = @($channels[$channel] | Sort-Object)
            $median = $sorted[[int]($sorted.Count / 2)]
            if ([Math]::Abs($median - $expected[$channel]) -gt 65) {
                throw "Unexpected color in $name at ($x,$y): channel $channel = $median."
            }
        }
    } finally { $bitmap.Dispose() }
}

CheckColor none 100 400 @(255, 0, 0)
CheckColor horizontal 100 400 @(0, 255, 255)
CheckColor vertical 100 400 @(255, 0, 0)
# The timestamp in the video moves from the top left to the bottom left.
CheckColor vertical 60 900 @(60, 0, 0) 10 10
CheckColor 90 100 400 @(0, 0, 0)
CheckColor 90 700 130 @(255, 0, 0)
CheckColor 90 700 300 @(0, 255, 0)
CheckColor 180 100 400 @(0, 255, 255)
CheckColor 270 100 400 @(0, 0, 0)
CheckColor 270 700 130 @(0, 255, 255)
CheckColor 270 700 300 @(255, 0, 255)
CheckColor restored 100 400 @(255, 0, 0)
CheckColor restored 600 400 @(255, 255, 0)
'PASS: horizontal/vertical flips, consecutive rotations and restoration have the expected video orientation.'
