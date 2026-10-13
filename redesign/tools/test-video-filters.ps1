# Regression check for live filter activation and display-format restoration.
# The local test clip must show red, green, yellow and blue vertical bars.
param([string]$Media = "$PSScriptRoot/Videos/clip-m.mp4")

$ErrorActionPreference = 'Stop'
$before = Join-Path $PSScriptRoot 'negate-before.png'
$enabled = Join-Path $PSScriptRoot 'negate-on.png'
$disabled = Join-Path $PSScriptRoot 'negate-off.png'

& "$PSScriptRoot/shot.ps1" -Media $Media -Out $disabled -VlcArgs '--no-audio', '--loop' `
    -Click "1325,1038;1105,105;w:1235,760,5;1220,630;s:$before;1345,845;p:1000;s:$enabled;1345,845;p:1000"

function MeanColor([System.Drawing.Bitmap]$bitmap, [int]$x) {
    $sum = @(0.0, 0.0, 0.0)
    $count = 0
    for ($px = $x; $px -lt $x + 60; $px += 3) {
        for ($py = 360; $py -lt 520; $py += 3) {
            $color = $bitmap.GetPixel($px, $py)
            $sum[0] += $color.R
            $sum[1] += $color.G
            $sum[2] += $color.B
            ++$count
        }
    }
    return @($sum | ForEach-Object { $_ / $count })
}

$images = @($before, $enabled, $disabled | ForEach-Object {
    [System.Drawing.Bitmap]::new($_)
})
try {
    foreach ($x in @(100, 330, 560, 790)) {
        $original = MeanColor $images[0] $x
        $negative = MeanColor $images[1] $x
        $restored = MeanColor $images[2] $x
        $change = 0
        $error = 0
        for ($channel = 0; $channel -lt 3; ++$channel) {
            $change += [Math]::Abs($negative[$channel] - $original[$channel])
            $error += [Math]::Abs($restored[$channel] - $original[$channel])
        }
        if ($change -lt 150) { throw "Negate Colors did not change the bar at x=$x." }
        if ($error -gt 60) { throw "Disabling Negate Colors did not restore the bar at x=$x (error $error)." }
    }
    'PASS: Negate Colors changes all four bars and restores their colors when disabled.'
} finally {
    $images | ForEach-Object { $_.Dispose() }
}
