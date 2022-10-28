#!/bin/bash
set -e
source dev-container-features-test-lib

check "[tfenv] list-remote" tfenv list-remote | head -n 10
check "[tfenv] Terraform version" terraform version

check "[tflint] version" tflint --version

check "[terraform-docs] version" terraform-docs --version

reportResults