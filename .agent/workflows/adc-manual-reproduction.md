---
description: Create and manage local Terraform experiments for reproducing App Design Center (ADC) issues in isolation.
---

# ADC Manual Reproduction Workflow

This workflow guides agents on how to safely reproduce ADC bugs or behaviors using minimal, local Terraform configurations. It guarantees that temporary resource code does not pollute the Git history or leave dangling resources in Google Cloud.

## Execution Steps

1. **Create an Isolated Experiment Directory**
   Ensure you create a localized experiment folder exclusively inside `modules/terraform-google-firebase/experiments/`.
   - *Example*: `modules/terraform-google-firebase/experiments/adc_issue_123`
   - *Note*: The `experiments/` directory is explicitly added to `.gitignore`.

2. **Draft Minimal Reproduction Code**
   Within the experiment directory, author the minimal `main.tf` necessary to emulate the ADC structure that causes the issue.

3. **Initialize and Apply**
   Run the following to deploy the localized experiment:
   ```bash
   terraform init
   terraform apply
   ```

4. **Verify Behavior**
   Read trace logs or inspect the GCP environment to confirm whether the reported ADC issue is reproduced.

5. **CRITICAL: Teardown**
   Once verification is complete, you MUST destroy the resources deployed in the experiment immediately:
   ```bash
   terraform destroy -auto-approve
   ```

6. **Cleanup Workspace**
   To maintain a clean working directory, delete the specific experiment folder:
   ```bash
   rm -rf modules/terraform-google-firebase/experiments/adc_issue_123
   ```
