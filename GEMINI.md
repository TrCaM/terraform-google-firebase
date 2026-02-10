# Firebase Module Development Guide

This document outlines the standard workflows for developing, verifying, and documenting the `terraform-google-firebase` module.

## 1. Environment Setup

### Prerequisites
Ensure you have a Service Account key with `Owner` permissions on the folder where you are creating test projects.

### Credentials & Variables
Export the following variables in your terminal before running any Docker commands:

Generate service account key with

```bash
gcloud services api-keys create --project=<PROJECT_ID> --display-name="DK API Key"
```

```bash
# Service Account for Terraform impersonation/provisioning
export SERVICE_ACCOUNT_JSON=$(cat ~/.credentials/my-sa-key.json)

# Setup variables for the transient test project
export TF_VAR_org_id="604050891148"
export TF_VAR_folder_id="829125971749"
export TF_VAR_billing_account="01B0E1-2A89E8-4601C4"
```

## 2. Development Workflow

### Repository Structure
- **`modules/`**: Contains the functional submodules (e.g., `firebase_core`, `firebase_auth`).
- **`examples/`**: Contains usage examples (e.g., `firebase_project`).
- **`test/`**: Contains integration tests and setup configuration.

### Local Development
To work inside the `developer-tools` container (which has terraform, cft, golang, etc.):

```bash
make docker_run
```

**Note**: The `SERVICE_ACCOUNT_JSON` variable must be exported before running this.

## 3. Verification & Testing

We use the standard CFT testing framework. The lifecycle consists of: `prepare` -> `integration` -> `cleanup`.

### Step 1: Prepare Test Project
Creates a transient Google Cloud Project for testing.
```bash
make docker_test_prepare
```

### Step 2: Run Integration Tests
Runs the Go-based integration tests (Blueprint Test) against the prepared project.
```bash
make docker_test_integration
```
*   This command executes `cft test run all` inside the container.

### Step 3: Cleanup
Destroys the transient project and resources.
```bash
make docker_test_cleanup
```

### Linting
To run formatting and license checks:
```bash
make docker_test_lint
```

## 4. Documentation & Metadata

### Generating Documentation
Updates `README.md` files in root and submodules with Inputs/Outputs tables.
```bash
make docker_generate_docs
```

### Generating Discovery Metadata
Generates `metadata.yaml` and `metadata.display.yaml` for the Service Catalog.
**Requirement**: All submodule `README.md` files must have an H1 title (e.g., `# Module Name`).

```bash
ENABLE_BPMETADATA=1 make docker_generate_docs
```
*   The `ENABLE_BPMETADATA=1` flag triggers the metadata generation logic.
*   It produces both the standard metadata and the display metadata (UI hints).

## 5. Troubleshooting common issues

### "Kitchen YAML file does not exist"
*   **Cause**: The older `test_integration.sh` script defaulted to Kitchen-Terraform.
*   **Fix**: We updated the `Makefile` to use `cft test run all` directly, which correctly detects the Go/Blueprint tests.
