#!/usr/bin/env bash
#
set -euo pipefail

log() {
  echo "[installer] $*" >&2
}

die() {
  log "$@"
  exit 1
}

kernel=$(uname -s | tr "[:upper:]" "[:lower:]")
case "${kernel}" in
  mingw*)
    kernel=windows
    ;;
esac
case "$(uname -m)" in
  x86_64)
    machine=amd64
    ;;
  i686 | i386)
    machine=386
    ;;
  aarch64 | arm64)
    machine=arm64
    ;;
  *)
    die "Machine $(uname -m) not supported by the installer.\n"
    ;;
esac
log "kernel=$kernel machine=$machine"

log "looking for a download URL"
if [ ${VERSION} == "latest" ]; then
  VERSION=$(
    curl -sfL "https://api.github.com/repos/hairyhenderson/gomplate/releases/latest" |\
    grep tag_name |\
    cut -d '"' -f 4
  )
  log latest=${VERSION}
fi
_release_url="https://api.github.com/repos/hairyhenderson/gomplate/releases/tags/${VERSION}"
log _release_url=${_release_url}
download_url=$(
  curl -sfL $_release_url \
  | grep browser_download_url \
  | cut -d '"' -f 4 \
  | grep "gomplate_${kernel}-${machine}$"
)
log "download_url=$download_url"

log "downloading"
curl -o "/usr/local/bin/gomplate" -fL "$download_url"
chmod +x "/usr/local/bin/gomplate"
