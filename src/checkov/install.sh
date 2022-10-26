#!/usr/bin/env bash
#
VERSION=${VERSION:-latest}
if [ ${VERSION} == "latest" ]; then
    pip install checkov
else
    pip install checkov==${VERSION}
fi