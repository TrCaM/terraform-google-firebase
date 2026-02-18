# Firebase AI Logic Integrated Example

This example demonstrates how to set up Firebase AI Logic (formerly Vertex AI in Firebase) using a modular approach. It integrates with the `firebase_multi_platform_application` module to ensure a prerequisite Firebase App exists before configuring AI Logic.

## Features
- **Project-wide Configuration**: Uses `firebase_ai_logic_core` to set up the Gemini API key and telemetry.
- **Prerequisite App Integration**: Automatically links to a Web App created via the `firebase_multi_platform_application` module.
- **Multiple Prompt Templates**: Demonstrates creating multiple templates (`firebase_ai_logic_prompt_template`).
- **Flexible Sourcing**: Shows both direct `template_string` usage and fetching content from a GCS bucket (`gcs_source`).

## Usage

1.  Set the `project_id` variable.
2.  Run `terraform init` and `terraform apply`.

```hcl
module "ai_logic_example" {
  source     = "TrCaM/firebase/google//examples/firebase_ai_logic"
  project_id = "your-project-id"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The location for the AI Logic configuration. | `string` | `"global"` | no |
| project\_id | The ID of the project to deploy to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ai\_logic\_config\_name | The name of the AI Logic configuration. |
| ai\_logic\_template\_names | The full resource names of the created prompt templates. |
| project\_id | The project ID. |
| web\_app\_id | The ID of the created web app. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
