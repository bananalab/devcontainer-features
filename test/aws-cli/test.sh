#!/bin/bash
set -e
source dev-container-features-test-lib
check "version" aws --version
reportResults