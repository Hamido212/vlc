# Regenerates VLC's icon font after VLCIcons.json or an icon changed.
#
# The glyphs whose path is in icons/redesign/ come from the Figma icons in
# redesign/icons/figma: they are outlined first (see outline.py), then VLC's
# own makeIconFont.py builds VLCIcons.ttf and style/vlcicons.{hpp,cpp}.

$ErrorActionPreference = 'Stop'

$image = 'vlc-redesign-icons'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

docker build -q -t $image $PSScriptRoot | Out-Null
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

docker run --rm -v "${repo}:/repo" -w /repo/modules/gui/qt/pixmaps $image sh -c `
    'rm -rf icons/redesign && python3 /repo/redesign/icons/outline.py VLCIcons.json /repo/redesign/icons/figma && python3 makeIconFont.py VLCIcons.json'
exit $LASTEXITCODE
