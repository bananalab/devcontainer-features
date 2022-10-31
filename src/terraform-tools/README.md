
# terraform-tools (terraform-tools)

Install and configure terraform-tools. terraform-docs, terragrunt, tfenv and tflint

## Example Usage

```json
"features": {
    "ghcr.io/bananalab/devcontainer-features/terraform-tools:0": {
        "version": "latest"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| install_terraform_docs | - | boolean | true |
| terraform_docs_version | terraform-docs version | string | latest |
| install_tflint | - | boolean | true |
| tflint_version | tflint version | string | latest |
| install_tfenv | - | boolean | true |
| tfenv_version | tfenv version | string | latest |
| tfenv_default_terraform_version | Terraform version to install version | string | latest |
| install_terragrunt | - | boolean | true |
| terragrunt_version | terragrunt version | string | latest |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/bananalab/devcontainer-features/blob/main/src/terraform-tools/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
