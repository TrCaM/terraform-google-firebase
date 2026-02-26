# Firebase Multi-Platform Application Example

This example demonstrates how to use the `firebase_multi_platform_application` submodule to bootstrap a Firebase project with Web, Android, and Apple apps.

## Usage

1.  Set up your Google Cloud project and billing account.
2.  Configure the required variables in a `terraform.tfvars` file or via environment variables.
3.  Run `terraform init`, `terraform plan`, and `terraform apply`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The project ID to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| project_id | The project ID |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The GCP project ID to use for the example. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| android\_config | Android app configuration. |
| app\_ids | The created app IDs. |
| apple\_config | Apple app configuration. |
| project\_id | The project ID. |
| web\_config | Web app configuration. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
