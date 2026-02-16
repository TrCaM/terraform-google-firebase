# Firebase Authentication GitHub Provider Submodule

This module configures GitHub Sign-In as an identity provider for Firebase Authentication (Identity Platform).

## Prerequisites

- The `firebase_auth_core` module must be applied to the project first.
- You must have a GitHub OAuth Client ID and Secret from the [GitHub Developer Settings](https://github.com/settings/developers).

## Usage

```hcl
module "auth_github" {
  source = "TrCaM/firebase/google//modules/firebase_auth_github"

  project_id    = "my-project-id"
  client_id     = var.github_client_id
  client_secret = var.github_client_secret
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_id | The GitHub OAuth Client ID (from GitHub Developer Settings) | `string` | n/a | yes |
| client\_secret | The GitHub OAuth Secret (from GitHub Developer Settings) | `string` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
