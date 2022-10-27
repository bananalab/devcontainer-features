#!/usr/bin/env bash
#
_tmpdir=$(mktemp -d)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${_tmpdir}/awscliv2.zip"
pushd ${_tmpdir}
unzip awscliv2.zip
./aws/install
popd

rm -rf ${_tmpdir}