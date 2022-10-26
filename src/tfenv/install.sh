#!/usr/bin/env bash
#
set -euo pipefail

VERSION=${VERSION:-"master"}
git clone --depth=1 https://github.com/tfutils/tfenv.git?ref=${VERSION} /opt/tfenv