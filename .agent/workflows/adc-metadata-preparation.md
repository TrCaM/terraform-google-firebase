---
description: Prepare and enhance Firebase Terraform metadata to be compliant with the App Design Center (ADC).
---

# ADC Metadata Preparation Workflow

This workflow details the critical combination of manual and automatic steps required to prepare Firebase metadata for ADC. ADC requires explicit type information (`varType`) for all output variables. This requires a dynamic analysis of the module.

## 1. Automatic Type Generation

Once the initial module code is ready, the documentation and metadata must be generated.

> [!IMPORTANT]
> **AGENT INSTRUCTION**: This step requires transient GCP project credentials and Docker, making it too dangerous to run autonomously. You **MUST prompt the user** to run the following steps manually and wait for their confirmation before proceeding.

### Step 1: Prepare Test Infrastructure
Ask the user to provide a temporary GCP project to allow the metadata tool to inspect actual Terraform outputs.
```bash
make docker_test_prepare
```

### Step 2: Create local `terraform.tfvars`
Ask the user to create a `terraform.tfvars` file in the module directory (and any submodules). This file unblocks the `cft` tool by providing values for required variables.
- Use the `project_id` from the project created in Step 1.
- **WARNING**: Remind the user not to commit these `terraform.tfvars` files.

### Step 3: Run Metadata Generation
Ask the user to run the doc and metadata generation using the CFT blueprints tool.
```bash
# Important! Enable BPMETADATA
export ENABLE_BPMETADATA=1

make docker_generate_docs
make docker_generate_metadata
```

**Wait for the user to finish and confirm these steps before proceeding.**

## 2. Manual Adjustments

The auto-generation may still require manual updates for certain variables.

### Step 1: Refine Data Types
Even after automatic type generation, complex input/output objects often need manual formatting refinement:
- **Input `varType`**: For objects/lists, use the `|-` YAML literal block scalar to write out the Terraform type signature. (See `firebase_auth` `auth_config` for an example).
- **Output `type`**: For complex objects, manually construct the YAML list hierarchy to describe the type accurately. (See `firebase_multi_platform_application` `app_check_bundle` for an example).

### Step 2: Connections
Inspect the generated metadata to ensure service connections are mapped properly. Manually add `connections` blocks for variables that rely on outputs from other modules (like `project_id`).

## 3. Metadata Validation & Example Restoration

You must validate that the generated metadata is schema-compliant.
```bash
export ENABLE_BPMETADATA=1
make docker_test_lint
```

> [!WARNING]
> Running `make docker_test_lint` will destroy the local module references in `examples/` (replacing them with GitHub links).

After linting succeeds, **you must revert** the `source` references in the `/examples` files back to the local relative paths (e.g. `source = "../../modules/firebase_auth"` instead of `source = "GoogleCloudPlatform/terraform-google-firebase..."`).

Running `generate_docs`, `generate_metadata`, and `lint` again with only the example reference changed and reverted will confirm the module codebase is in a fully healthy state.
