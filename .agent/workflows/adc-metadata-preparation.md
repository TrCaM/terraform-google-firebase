---
description: Prepare and enhance Firebase Terraform metadata to be compliant with the App Design Center (ADC).
---

# ADC Metadata Preparation Workflow

This workflow details the critical combination of manual and automatic steps required to prepare Firebase metadata for ADC. ADC requires explicit type information (`varType`) for all output variables. This requires a dynamic analysis of the module.

## 1. Automatic Type Generation

Once the initial module code is ready, run the following commands to generate/update documentation and metadata simultaneously.

### Step 1: Prepare Test Infrastructure
Provide a temporary GCP project to allow the metadata tool to inspect actual Terraform outputs.
```bash
make docker_test_prepare
```

### Step 2: Create local `terraform.tfvars`
Create a `terraform.tfvars` file in the module directory (and any submodules). This file unblocks the `cft` tool by providing values for required variables.
- Use the `project_id` from the project created in Step 1.
- **WARNING**: Do not commit these `terraform.tfvars` files.

### Step 3: Run Metadata Generation
Run the doc and metadata generation using the CFT blueprints tool. 
```bash
# Important! Enable BPMETADATA
export ENABLE_BPMETADATA=1

make docker_generate_docs
make docker_generate_metadata
```

## 2. Manual Adjustments

The auto-generation may still require manual updates for certain variables:
1. `connections`: Inspect the generated metadata to ensure service connections are mapped properly.
2. `input/output` variable types: If some objects aren't cleanly typed, they might need tweaking.

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
