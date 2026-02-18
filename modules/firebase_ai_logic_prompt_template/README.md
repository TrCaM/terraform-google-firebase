# Firebase AI Logic Prompt Template Submodule

This module manages individual prompt templates for Firebase AI Logic.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_lock | Whether to create a production lock for the prompt template. | `bool` | `false` | no |
| gcs\_source | Object containing bucket and name to fetch prompt content from GCS. | <pre>object({<br>    bucket = string<br>    name   = string<br>  })</pre> | `null` | no |
| location | The location for the prompt template. | `string` | `"global"` | no |
| project\_id | The project ID. | `string` | n/a | yes |
| template\_id | The unique identifier for the prompt template. | `string` | n/a | yes |
| template\_string | Direct text input for the prompt template content. Overrides gcs\_source if provided. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| template\_id | The template identifier. |
| template\_name | The full resource name of the template. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
