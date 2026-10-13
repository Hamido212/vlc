# FontForge for redesign/icons/update.ps1, on top of the image the build
# already uses.
FROM registry.videolan.org/vlc-debian-win64-posix:20260611225331
USER root
RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends python3-fontforge \
    && rm -rf /var/lib/apt/lists/*
