#!/bin/bash
set -e
source dev-container-features-test-lib

check "list-remote" tfenv list-remote | head -n 10
check "Terraform version" terraform version
reportResults