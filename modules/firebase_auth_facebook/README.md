# Firebase Authentication Facebook Provider Submodule

This module configures Facebook Sign-In as an identity provider for Firebase Authentication (Identity Platform).

## Prerequisites

- The `firebase_auth_core` module must be applied to the project first.
- You must have a Facebook App ID and App Secret from the [Meta for Developers](https://developers.facebook.com/) portal.

## Usage

```hcl
module "auth_facebook" {
  source = "TrCaM/firebase/google//modules/firebase_auth_facebook"

  project_id          = "my-project-id"
  facebook_app_id     = var.facebook_app_id
  facebook_app_secret = var.facebook_app_secret
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| facebook\_app\_id | The Facebook App ID (from Meta for Developers) | `string` | n/a | yes |
| facebook\_app\_secret | The Facebook App Secret (from Meta for Developers) | `string` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
