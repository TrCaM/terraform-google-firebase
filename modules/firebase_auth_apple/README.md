# Firebase Authentication Apple Provider Submodule

This module configures Apple Sign-In as an identity provider for Firebase Authentication (Identity Platform).

## Prerequisites

- The `firebase_auth_core` module must be applied to the project first.
- You must have the necessary identifiers (Service ID, Team ID, Key ID) and the private key file (.p8) from the [Apple Developer Portal](https://developer.apple.com/).

## Usage

```hcl
module "auth_apple" {
  source = "TrCaM/firebase/google//modules/firebase_auth_apple"

  project_id    = "my-project-id"
  service_id    = var.apple_service_id
  team_id       = var.apple_team_id
  key_id        = var.apple_private_key_id
  client_secret = var.apple_private_key_content
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_secret | The content of the Apple Private Key file (.p8) | `string` | n/a | yes |
| key\_id | The Apple Private Key ID (from Apple Developer Portal) | `string` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| service\_id | The Apple Service ID (from Apple Developer Portal) | `string` | n/a | yes |
| team\_id | The Apple Team ID (from Apple Developer Portal) | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
