# Firebase Module Development Guide

This document outlines the standard workflows for developing, verifying, and documenting the `terraform-google-firebase` module.

> [!IMPORTANT]
> **Agent Execution Rule (Docker):** Before running ANY `make docker ...` commands (e.g., `make docker_test_lint`, `make docker_test_integration`, etc.), you MUST highlight the exact command you are about to run and request explicitly for the user's review and approval. Do not execute these commands without prior confirmation.
>
> **Agent Execution Rule (Git):** Before running ANY `git` commands, you MUST explain every command you are about to execute. Git commands are potentially dangerous, and the user must understand the plan and verify it before you are allowed to proceed.

## 1. Environment Setup

### Prerequisites
To run CFT integration tests, you need a Service Account key with `Owner` permissions on the folder where you are creating transient test projects.
**Contributors:** Ask the Firebase team for access to the central billing project. This project will be used to generate the Service Account key that provisions test projects.

### Credentials & Variables
Export the following variables in your terminal before running any Docker commands.

To generate the service account key from the billing project:
```bash
gcloud iam service-accounts keys create /tmp/cft.json --iam-account=<SERVICE_ACCOUNT_EMAIL>
```

```bash
# Service Account for Terraform impersonation/provisioning
export SERVICE_ACCOUNT_JSON=$(< /tmp/cft.json)

# Setup variables for the transient test project
export TF_VAR_org_id="<ORG_ID>"
export TF_VAR_folder_id="<FOLDER_ID>"
export TF_VAR_billing_account="<BILLING_ACCOUNT_ID>"
```

## 2. Development Workflow

### Repository Structure
- **`modules/`**: Contains the functional submodules (e.g., `firebase_core`, `firebase_auth`).
- **`examples/`**: Contains usage examples (e.g., `firebase_project`).
- **Git-on-Borg Expert**: Specialized knowledge for internal Google Git (Git-on-Borg/GoB) and Gerrit workflows.
  - Load: `../../.agent/skills/git-on-borg-expert/SKILL.md`
- **Git Worktree Ops**: For managing multi-repo workflows and feature branches.
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

## 6. Submodule Development Flow

When developing a new submodule (e.g., `firebase_multi_platform_application`), follow this iterative process:

1.  **Brainstorm**:
    - Identify the core objective (e.g., high-level bootstrapping vs. granular resource management).
    - Research API idempotency and resource behavior (e.g., what happens if redundant `google_firebase_project` resources exist).
2.  **Plan**:
    - Draft an `implementation_plan.md`.
    - Define variable structures (e.g., using `optional()` objects) and outputs.
    - Confirm with the user/stakeholders before writing code.
3.  **Implementation**:
    - Build `main.tf`, `variables.tf`, and `outputs.tf`.
    - Use `count` for conditional resource creation and `try()` for safe output evaluation.
    - Ensure self-healing bootstrap logic (e.g., including `google_project_service`).
4.  **Manual Test**:
    - Create a scratch space (e.g., `tests/manual_multi_app/`).
    - Verify scenarios with multiple module instances to ensure idempotency and robustness.
    - Run `terraform plan` and `terraform apply`.
    - Destroy resources immediately after verification.
5.  **Documentation & Discovery**:
    - Updates `README.md` files in root and submodules with Inputs/Outputs tables.
    - Generate discovery metadata for the Service Catalog.
    ```bash
    make docker_generate_docs
    ENABLE_BPMETADATA=1 make docker_generate_docs
    ```
6.  **Automatic Testing**:
    - We use the Go-based Blueprint framework for integration testing.
    - Test files are located in `test/integration/`.
    - Run the full test suite using:
      ```bash
      make docker_test_integration
      ```
    - The framework automatically discovers tests. See `test/integration/discover_test.go` for the entry point.
