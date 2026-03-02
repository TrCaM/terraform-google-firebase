---
name: adc-compliant-development
description: Specialized skill for developing App Design Center (ADC) compliant Terraform blueprints and editing metadata.
---

# ADC Compliant Module Development Skill

This skill provides step-by-step instructions for developing or updating a Terraform module to be fully compliant with the Google Cloud App Design Center (ADC). ADC requires rich metadata (`metadata.yaml` and `metadata.display.yaml`) to automatically render drag-and-drop components in its UI.

## 1. Ensure Configuration Compliance
Before generating metadata, the underlying Terraform module must follow ADC blueprint rules:
- Ensure all project-level resources explicitly declare `project_id` rather than inheriting from the provider config.
- Use standard variable names: `project_id`, `region`, `zone`, `location`, `labels`.
- Do not bundle Service and Workload type resources together. Horizontal services like IAM and SA can be bundled.

## 2. Generate Initial Metadata and Output Types
Metadata generation creates the base `metadata.yaml` and `metadata.display.yaml`. ADC requires that **each output variable has its type explicitly defined** in the metadata. 

> [!IMPORTANT]
> **AGENT INSTRUCTION**: Generating metadata requires a real Google Cloud Project ID and Docker execution, which is too dangerous to do autonomously. You **MUST pause and ask the user** to manually execute the following steps in their terminal. Provide them with instructions similar to these:

1. Prepare transient infrastructure:
   ```bash
   make docker_test_prepare
   ```
2. Create a local `terraform.tfvars` file for the module (and its submodules) with the `project_id` value of the transient project created above. **Do not commit this file.**
3. Drop into the developer container:
   ```bash
   make docker_run
   ```
4. Generate documentation and output types (inside the container):
   ```bash
   make generate_docs
   cft blueprint metadata --generate-output-type
   ```
   *Note: If `metadata.display.yaml` doesn't generate automatically, the user may need to enable it via `ENABLE_BPMETADATA=1 make generate_docs` outside the container, or by updating the module's Makefile.*

**Wait for the user to confirm they have completed these steps before you proceed to update the generated metadata files.**

## 3. Manually Refine Data Types
Even after automatic generation, the `varType` (for inputs) and `type` (for outputs) often need manual refinement to ensure ADC can parse complex objects correctly.

### Refining Input `varType`
For complex input variables (like objects or lists of objects), use the `|-` YAML literal block scalar to define the Terraform type signature across multiple lines.
*Example (from `firebase_auth`)*:
```yaml
      - name: auth_config
        varType: |-
          object({
              allow_duplicate_emails  = optional(bool, false)
              anonymous_enabled       = optional(bool, false)
              email_enabled           = optional(bool, false)
            })
```

### Refining Output `type`
Output types in `metadata.yaml` must be explicitly structured as YAML lists/maps representing the type hierarchy, not a single string.
*Example (from `firebase_multi_platform_application`)*:
```yaml
      - name: app_check_bundle
        type:
          - object
          - android:
              - list
              - - object
                - app_id: string
                  token_ttl: string
```

## 4. Update `metadata.yaml` (Connections)
Connections allow ADC to map an output from one blueprint to an input of another.
Find variables that rely on outputs from other modules (e.g. `project_id` or `service_account`) and manually add a `connections` block:

### Defining the `outputExpr`
The `outputExpr` spec is critical and controls how data from the composed module's output is structured for this input.
> **Note**: Terraform functions are not supported within the `outputExpr` for connections.

**Supported `outputExpr` syntax:**
1. **Direct Variable Selection**:
   - `outputExpr: output_variable_name`
   - `outputExpr: output_variable_name[0]`
   - `outputExpr: output_variable_name.field_name`

2. **Map/Object Transformation (JSON formatted strings)**:
   - `outputExpr: "{\"constant_key\": \"constant_value\"}"`
   - `outputExpr: "{\"constant_key\": output_variable_name}"`
   - `outputExpr: "{\"constant_key\": output_variable_name[0]}"`
   - `outputExpr: "{\"constant_key\": output_variable_name.field_name}"`

3. **Constant Values**:
   - `outputExpr: "[\"constant_value\"]"`
   - `outputExpr: "1234"`
   - `outputExpr: "false"`

*Example (from `firebase_app_check`)*:
Here, the `web_apps` input is fed by the `app_check_bundle.web` field of the `app_check_bundle` output from the `firebase_multi_platform_application` module.

```yaml
      - name: web_apps
        description: List of Web apps to configure for App Check.
        varType: |-
          list(object({
              app_id              = string
              site_key            = optional(string)
            }))
        defaultValue: []
        connections:
          - source:
              source: github.com/TrCaM/terraform-google-firebase//modules/firebase_multi_platform_application
              version: ">= 12.23.0"
            spec:
              outputExpr: app_check_bundle.web
```

### Designing Modules for Easy ADC Connections
Because ADC `outputExpr` **does not support Terraform functions** (like `merge`, `concat`, filtering, or looping), it heavily influences how you design Terraform modules. 

The composing module (upstream) must do the heavy lifting to structure its `outputs` so the downstream module can consume them with a simple variable selection.

**Key Design Pattern: The "Bundle" Output**
Instead of outputting raw, unstructured IDs or parallel lists, the upstream module should use Terraform `locals` and `for` expressions to construct a single output object perfectly shaped for the downstream module's input.

*Example*: The `firebase_multi_platform_application` module needs to pass multiple web, android, and apple app configurations to the `firebase_app_check` module.
If it outputted just a flat list of App IDs, the ADC connection would fail because `firebase_app_check` needs complex objects (`app_id`, `site_key`, `token_ttl`). Since ADC cannot run a `for` loop in `outputExpr` to build these objects, the upstream module does it instead:

**Upstream (`firebase_multi_platform_application` outputs.tf):**
Builds the `app_check_bundle` explicitly shaped for the downstream module:
```hcl
output "app_check_bundle" {
  description = "A structured object containing verified app IDs and metadata tailored for the Firebase App Check module."
  value = {
    web     = [for app in local.web_apps : { app_id = app.app_id, ... }]
    android = [for app in local.android_apps : { app_id = app.app_id, ... }]
    apple   = [for app in local.apple_apps : { app_id = app.app_id, ... }]
  }
}
```

**Downstream (`firebase_app_check` metadata.yaml):**
The connection expression becomes a trivial field lookup:
```yaml
      - name: web_apps
        varType: |-
          list(object({
              app_id              = string
              site_key            = optional(string)
            }))
        connections:
          - source:
              source: github.com/TrCaM/terraform-google-firebase//modules/firebase_multi_platform_application
              version: ">= 12.23.0"
            spec:
              outputExpr: app_check_bundle.web
```

## 5. Configure ADC UI via `metadata.display.yaml`
This file controls how variables map to visual components in the ADC UI.

1. **Promote Optional Inputs**: To surface an optional variable from "Advanced Fields" to the default view, add `level: 1`:
```yaml
        enforcement_mode:
          name: enforcement_mode
          title: Enforcement Mode
          level: 1
```

2. **Add Input Validations Settings**:
  - Regular expressions: Add `regexValidation` and `validation` attributes.
  - Dropdown Menus: Limit string variables to specific choices using `enumValueLabels`:
```yaml
        service_ids:
          name: service_ids
          title: Protected Services
          enumValueLabels:
            - label: Firebase Authentication
              value: identitytoolkit.googleapis.com
          level: 1
```

3. **Expose Useful Outputs**: For outputs that other composing blueprints need, set visibility to `VISIBILITY_ROOT`:
```yaml
    runtime:
      outputs:
        enabled_app_ids:
          visibility: VISIBILITY_ROOT
```

## 6. Validate and Restore State
Linting the metadata ensures schema compliance but alters `examples/` source paths.
1. Run Linting:
   ```bash
   export ENABLE_BPMETADATA=1 
   make docker_test_lint
   ```
2. Manually **revert** the `source` fields in your `examples/*/main.tf` files back to relative paths (e.g., `source = "../../modules/firebase_ai_logic_core"`).
3. If necessary, confirm tests still pass via `make docker_test_integration`.
