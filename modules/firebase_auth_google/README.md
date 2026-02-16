# Firebase Authentication Google Provider Submodule

This module configures Google Sign-In as an identity provider for Firebase Authentication (Identity Platform).

## Prerequisites

- The `firebase_auth_core` module must be applied to the project first.
- You must have a Google OAuth Web Client ID and Secret from the [Google Cloud Console](https://console.cloud.google.com/apis/credentials).

## Usage

```hcl
module "auth_google" {
  source = "TrCaM/firebase/google//modules/firebase_auth_google"

  project_id    = "my-project-id"
  client_id     = var.google_client_id
  client_secret = var.google_client_secret
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_id | The Google Web Client ID (from Google Cloud Console) | `string` | n/a | yes |
| client\_secret | The Google Web Client Secret (from Google Cloud Console) | `string` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
