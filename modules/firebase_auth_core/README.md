# Firebase Authentication Core Submodule

This module manages the core Identity Platform configuration for a Google Cloud project. It is a prerequisite for using other Firebase Authentication provider modules.

## Features

- Enables the Identity Platform singleton for the project.
- Configures global authentication settings:
  - Email/Password sign-in (with optional email link sign-in).
  - Phone number sign-in with test phone number support.
  - Anonymous sign-in.
  - Multi-tenancy support.
  - Duplicate email account linking settings.

## Usage

```hcl
module "auth_core" {
  source = "TrCaM/firebase/google//modules/firebase_auth_core"

  project_id             = "my-project-id"
  email_enabled          = true
  anonymous_enabled      = true
  allow_duplicate_emails = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_duplicate\_emails | Whether to allow multiple accounts with the same email address | `bool` | `false` | no |
| anonymous\_enabled | Whether to enable Anonymous sign-in | `bool` | `false` | no |
| email\_enabled | Whether to enable Email/Password sign-in | `bool` | `false` | no |
| email\_password\_required | Whether a password is required for email sign-in. If false, email link sign-in is enabled. | `bool` | `true` | no |
| multi\_tenancy\_enabled | Whether to enable multi-tenancy for the Identity Platform configuration. If null, the block is omitted (but may cause drift if the API returns a default). | `bool` | `false` | no |
| phone\_enabled | Whether to enable Phone number sign-in | `bool` | `false` | no |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| test\_phone\_numbers | Map of test phone numbers to their verification codes (e.g., '+16505551234' = '123456') | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_name | The name of the Identity Platform configuration |
| project\_id | The project ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
