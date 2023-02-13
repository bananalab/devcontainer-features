#!/usr/bin/env bash
#
_tmpdir=$(mktemp -d)
_arch=$(uname -m)
curl "https://awscli.amazonaws.com/awscli-exe-linux-${_arch}.zip" -o "${_tmpdir}/awscliv2.zip"
pushd ${_tmpdir}
unzip awscliv2.zip
./aws/install
popd

rm -rf ${_tmpdir}