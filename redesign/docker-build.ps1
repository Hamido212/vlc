# Builds VLC for Windows (x86_64) with VideoLAN's own build image and puts a
# runnable tree in build-win64\ at the top of the checkout.
#
#   .\redesign\docker-build.ps1          full build (first run takes a while)
#   .\redesign\docker-build.ps1 make     build what changed, skips configure
#   .\redesign\docker-build.ps1 qt       only rebuild the Qt interface plugin
#
# Needs Docker Desktop running. The build tree lives in the Docker volume
# "vlc-redesign-work"; remove that volume to start from scratch.

param(
    [ValidateSet('full', 'make', 'qt')]
    [string]$Mode = 'full',
    # Qt's C++ needs around 1 GB per compiler process, keep this below the
    # memory Docker's VM has.
    [int]$Jobs = 6,
    # Start the build in the background, follow it with
    # "docker logs -f vlc-redesign-build".
    [switch]$Detach
)

$ErrorActionPreference = 'Stop'

# Keep in sync with VLC_WIN64_IMAGE in extras/ci/gitlab-ci.yml, the prebuilt
# contribs are only usable with the compiler they were built with.
$image = 'registry.videolan.org/vlc-debian-win64-posix:20260611225331'
$volume = 'vlc-redesign-work'
$container = 'vlc-redesign-build'

$repo = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$out = Join-Path $repo 'build-win64'
New-Item -ItemType Directory -Force $out | Out-Null

# Same lookup as extras/ci/get-contrib-sha.sh, done here because the source
# copy inside the container has no .git.
$contribSha = git -C $repo rev-list -1 HEAD -- extras/tools contrib extras/ci extras/package/win32
$revision = git -C $repo describe --tags --long --match '?.*.*' --always

# The image builds as an unprivileged user, a fresh volume belongs to root.
docker run --rm --user root -v "${volume}:/work" $image chown videolan:videolan /work
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

docker rm -f $container 2>$null | Out-Null

$runArgs = @(
    'run', $(if ($Detach) { '-d' } else { '--rm' }),
    '--name', $container,
    '-v', "${repo}:/host/src:ro",
    '-v', "${out}:/host/out",
    '-v', "${volume}:/work",
    '-e', "VLC_CONTRIB_SHA=$contribSha",
    '-e', "VLC_REVISION=$revision",
    '-e', "JOBS=$Jobs",
    $image, 'sh', '/host/src/redesign/container-build.sh', $Mode
)
docker @runArgs

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ($Detach) {
    Write-Host "Build started, follow it with: docker logs -f $container"
} else {
    Write-Host "VLC is in $out - start it with $out\vlc.exe"
}
