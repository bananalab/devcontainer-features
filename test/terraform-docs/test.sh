#!/bin/bash
set -e
source dev-container-features-test-lib
file $(which terraform-docs)
check "version" terraform-docs version
reportResults