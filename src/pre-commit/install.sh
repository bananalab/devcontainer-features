#!/usr/bin/env bash
#
VERSION=${VERSION:-latest}
if [ ${VERSION} == "latest" ]; then
    pip install pre-commit
else
    pip install pre-commit==${VERSION}
fi