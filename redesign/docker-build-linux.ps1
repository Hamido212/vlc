# Builds VLC for Linux (x86_64) with VideoLAN's own Debian image, to see that
# the redesign compiles and runs there. The build stays in the Docker volume
# "vlc-redesign-linux-work": it needs the libraries of the image and is of no
# use outside of it.
#
#   .\redesign\docker-build-linux.ps1          full build (first run takes a while)
#   .\redesign\docker-build-linux.ps1 make     build what changed, skips configure
#   .\redesign\docker-build-linux.ps1 qt       only rebuild the Qt interface plugin
#   .\redesign\docker-build-linux.ps1 shot     start it without a screen and take a
#                                              picture, to build-linux\vlc-linux.png
#
# Needs Docker Desktop running.

param(
    [ValidateSet('full', 'make', 'qt', 'shot')]
    [string]$Mode = 'full',

    # Qt's C++ needs around 1 GB per compiler process, keep this below the
    # memory Docker's VM has.
    [int]$Jobs = 6,

    # For "shot": a file under redesign\tools\Videos to play, and how long to
    # wait before the picture.
    [string]$Media = '',
    [int]$Wait = 25,

    # Start the build in the background, follow it with
    # "docker logs -f vlc-redesign-linux-build".
    [switch]$Detach
)

$ErrorActionPreference = 'Stop'

# Keep in sync with VLC_DEBIAN_IMAGE in extras/ci/gitlab-ci.yml.
$image = 'registry.videolan.org/vlc-debian-unstable:20260611225331'
$volume = 'vlc-redesign-linux-work'
$container = 'vlc-redesign-linux-build'

$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$out = Join-Path $repo 'build-linux'
New-Item -ItemType Directory -Force $out | Out-Null

$revision = git -C $repo describe --tags --long --match '?.*.*' --always

# The image builds as an unprivileged user, a fresh volume belongs to root.
docker run --rm --user root -v "${volume}:/work" $image chown videolan:videolan /work
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

docker rm -f $container 2>$null | Out-Null

$runArgs = @(
    'run', $(if ($Detach) { '-d' } else { '--rm' }), '--name', $container,
    '-v', "${repo}:/host/src:ro",
    '-v', "${out}:/host/out",
    '-v', "${volume}:/work",
    '-e', "VLC_REVISION=$revision",
    '-e', "JOBS=$Jobs",
    '-e', "VLC_WAIT=$Wait"
)
if ($Media) { $runArgs += @('-e', "VLC_MEDIA=/host/src/redesign/tools/Videos/$Media") }
$runArgs += @($image, 'sh', '/host/src/redesign/container-build-linux.sh', $Mode)

docker @runArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if ($Detach) {
    Write-Host "Build started, follow it with: docker logs -f $container"
}
