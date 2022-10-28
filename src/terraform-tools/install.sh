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

get_latest() {
  local _repo=${1}
  local _latest_version=$(
    curl -sfL "https://api.github.com/repos/${_repo}/releases/latest" |\
    grep tag_name |\
    cut -d '"' -f 4
  )
  echo ${_latest_version}
}

get_release_url() {
  local _repo=${1}
  local _version=${2}
  local _release_url=""
  if [ "${_version}" == "latest" ]; then
    _release_url="https://api.github.com/repos/${_repo}/releases/tags/$(get_latest ${_repo})"
  else
    _release_url="https://api.github.com/repos/${_repo}/releases/tags/${_version}"
  fi
  echo ${_release_url}
}

get_kernel() {
  local _kernel=$(uname -s | tr "[:upper:]" "[:lower:]")
  echo ${_kernel}
}

get_machine() {
  _arch="$(uname -m)"
  case ${_arch} in
    x86_64)
      local _machine=amd64
      ;;
    i686 | i386)
      local _machine=386
      ;;
    aarch64 | arm64)
      local _machine=arm64
      ;;
    *)
      log "Machine ${_arch} not supported by the installer.\n"
      ;;
  esac
  echo ${_machine}
}

get_release_archive_url() {
  local _repo=${1}
  local _version=${2}
  local _pattern=${3}
  local _release_url=$(get_release_url ${_repo} ${_version})
  local _download_url=''
  if [ ${_pattern} == 'tarball' ]; then
    _download_url=$(
      curl -sfL ${_release_url} \
      | grep tarball \
      | cut -d '"' -f 4
    )
  else
    _download_url=$(
      curl -sfL ${_release_url} \
      | grep browser_download_url \
      | cut -d '"' -f 4 \
      | grep "${_pattern}"
    )
  fi
  echo ${_download_url}
}

download_and_install_tfenv() {
  local _version=${1}
  local _repo="tfutils/tfenv"
  local _archive_url=$(get_release_archive_url ${_repo} ${_version} 'tarball')
  local _tmpdir=$(mktemp -d)
  curl -o "${_tmpdir}/tfenv.tar.gz" -sfL "${_archive_url}"
  pushd ${_tmpdir}
    tar -xf tfenv.tar.gz
    mkdir -p /opt/tfenv
    mv ${_tmpdir}/tfutils-tfenv-*/* /opt/tfenv
    ln -s /opt/tfenv/bin/* /usr/local/bin
  popd
  rm -rf ${_tmpdir}
  mkdir -p /opt/tfenv/versions
  chmod 777 /opt/tfenv/versions
  tfenv install ${TFENV_DEFAULT_TERRAFORM_VERSION}
  tfenv use ${TFENV_DEFAULT_TERRAFORM_VERSION}
  chmod 777 /opt/tfenv/version  
}

download_and_install_tflint() {
  local _version=${1}
  local _repo="terraform-linters/tflint"
  local _archive_url=$(get_release_archive_url ${_repo} ${_version} "tflint_$(get_kernel)_$(get_machine).zip")
  local _tmpdir=$(mktemp -d)
  curl -o "${_tmpdir}/tflint.zip" -sfL "${_archive_url}"
  pushd "${_tmpdir}"
    unzip tflint.zip
    chmod +x tflint
    mv tflint /usr/local/bin
  popd
  rm -rf ${_tmpdir}
}

download_and_install_terraform_docs() {
  local _version=${1}
  local _repo="terraform-docs/terraform-docs"
  if [ "${_version}" == "latest" ]; then
    _version="$(get_latest ${_repo})"
  fi
  local _archive_url=$(get_release_archive_url ${_repo} ${_version} "terraform-docs-${_version}-$(get_kernel)-$(get_machine).tar.gz")
  local _tmpdir=$(mktemp -d)
  curl -o "${_tmpdir}/terraform-docs.tar.gz" -fL "${_archive_url}"
  pushd "${_tmpdir}"
    tar -xf terraform-docs.tar.gz
    chmod +x terraform-docs
    mv terraform-docs /usr/local/bin
  popd
  rm -rf "${_tmpdir}"
}

if [ "${INSTALL_TFENV}" == "true" ]; then
  download_and_install_tfenv ${TFENV_VERSION}
fi

if [ "${INSTALL_TFLINT}" == "true" ]; then
  download_and_install_tflint ${TFLINT_VERSION}
fi

if [ "${INSTALL_TERRAFORM_DOCS}" == "true" ]; then
  download_and_install_terraform_docs ${TERRAFORM_DOCS_VERSION}
fi
