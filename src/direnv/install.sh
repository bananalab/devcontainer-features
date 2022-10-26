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

at_exit() {
  ret=$?
  if [[ $ret -gt 0 ]]; then
    log "the script failed with error $ret.\n"
  fi
  exit "$ret"
}
trap at_exit EXIT

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
    die "Machine $(uname -m) not supported by the installer.\n" \
      "Go to https://direnv for alternate installation methods."
    ;;
esac
log "kernel=$kernel machine=$machine"

: "${use_sudo:=}"
: "${bin_path:=}"

if [[ -z "$bin_path" ]]; then
  log "bin_path is not set, you can set bin_path to specify the installation path"
  log "e.g. export bin_path=/path/to/installation before installing"
  log "looking for a writeable path from PATH environment variable"
  for path in $(echo "$PATH" | tr ':' '\n'); do
    if [[ -w $path ]]; then
      bin_path=$path
      break
    fi
  done
fi
if [[ -z "$bin_path" ]]; then
  die "did not find a writeable path in $PATH"
fi
echo "bin_path=$bin_path"

log "looking for a download URL"
if [ ${VERSION} == "latest" ]; then
  _release_url="https://api.github.com/repos/direnv/direnv/releases/latest"
else
  _release_url="https://api.github.com/repos/direnv/direnv/releases/tags/${VERSION}"
fi
download_url=$(
  curl -fL $_release_url \
  | grep browser_download_url \
  | cut -d '"' -f 4 \
  | grep "direnv.$kernel.$machine"
)

log "download_url=$download_url"
log "downloading"
curl -o "$bin_path/direnv" -fL "$download_url"
chmod +x "$bin_path/direnv"

# ** Shell customization section **
log hooking bash
echo 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc

log hooking zsh
echo 'eval "$(direnv hook zsh)"' >> /etc/zsh/zshrc

if [ ${AUTO_ALLOW_WORKSPACES} == "true" ]; then
  log Writing direnv.toml
  echo "[whitelist]" > /etc/direnv.toml
  echo 'prefix = [ "/workspaces" ]' >> /etc/direnv.toml
fi
