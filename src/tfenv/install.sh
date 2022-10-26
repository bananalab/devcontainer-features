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

log "looking for a download URL"
if [ ${VERSION} == "latest" ]; then
  _release_url="https://api.github.com/repos/tfutils/tfenv/releases/latest"
else
  _release_url="https://api.github.com/repos/tfutils/tfenv/releases/tags/${VERSION}"
fi

download_url=$(
  curl -fL https://api.github.com/repos/tfutils/tfenv/releases/latest | \
  grep tarball | \
  cut -d '"' -f 4
)
echo "download_url=$download_url"

log "downloading"
curl -o "tfenv.tar.gz" -fL "$download_url"

_tmpdir=$(mktemp -d)
tar -xf tfenv.tar.gz -C ${_tmpdir}

mkdir -p /opt/tfenv
mv ${_tmpdir}/tfutils-tfenv-*/* /opt/tfenv
ln -s /opt/tfenv/bin/* /usr/local/bin
rm -rf ${_tmpdir}

mkdir -p /opt/tfenv/versions
chmod 777 /opt/tfenv/versions
