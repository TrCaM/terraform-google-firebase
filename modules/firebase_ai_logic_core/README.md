# Firebase AI Logic Core Submodule

This module manages the project-wide global configuration for Firebase AI Logic.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_key | The Gemini API key for server-side configuration. | `string` | `null` | no |
| app\_id | The App ID for a Firebase app in the project. Required if create\_app is false. | `string` | `null` | no |
| create\_app | Whether to create a default Firebase Web App if no app\_id is provided. | `bool` | `true` | no |
| location | The location for the AI Logic configuration. | `string` | `"global"` | no |
| project\_id | The project ID to deploy to. | `string` | n/a | yes |
| telemetry\_mode | Telemetry mode for AI Logic (e.g., ALL, NONE). | `string` | `"NONE"` | no |
| telemetry\_sampling\_rate | Sampling rate for telemetry. | `number` | `1` | no |
| verify\_app | Whether to verify the existence of the provided app\_id using a data source. Opt-in recommended only for non-computed app IDs. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_name | The name of the AI Logic configuration. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
