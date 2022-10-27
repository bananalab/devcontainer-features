#!/usr/bin/env bash
#
set -euo pipefail

if [ ${VERSION} == "latest" ]; then
    VERSION=$(
        curl -s "https://storage.googleapis.com/storage/v1/b/cloud-sdk-release/o?prefix=google-cloud-cli-" |\
        grep selfLink |\
        cut -d '"' -f 4 |\
        grep linux-x86.tar.gz |\
        sort -r |\
        head -n 1 |\
        cut -d '-' -f 6
    )
fi

_tmpdir=$(mktemp -d)
curl -o "${_tmpdir}/gcloud.tar.gz" https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${VERSION}-linux-x86_64.tar.gz

pushd ${_tmpdir}
tar -xf gcloud.tar.gz
mv google-cloud-sdk /opt
popd

rm -rf ${_tmpdir}

pushd /opt
./google-cloud-sdk/install.sh
echo '# ****** BEGIN GCLOUD CONFIG *****' >> /etc/bash.bashrc
echo 'source /opt/google-cloud-sdk/path.bash.inc'  >> /etc/bash.bashrc
echo 'source /opt/google-cloud-sdk/completion.bash.inc' >> /etc/bash.bashrc
echo '# ****** END GCLOUD CONFIG *****' >> /etc/bash.bashrc
popd
