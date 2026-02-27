---
name: adc-release-guide
description: Specialized skill for executing App Design Center (ADC) module release imports.
---

# ADC Release Guide Skill

This skill provides the authoritative knowledge necessary to safely deploy Firebase modules to the Google Cloud App Design Center (ADC).

## 1. Release Flow Fundamentals
ADC models Terraform modules as "Templates" which can have multiple sequential "Revisions".
Every Firebase module (e.g. `firebase_multi_platform_application`, `firebase_app_check`, `firebase_auth`) shares a unified release cycle governed by `./scripts/import_adc.sh`.

### Key Requirements Before Releasing
1. **Template Containers must exist**: The ADC Space and Catalog must already have the parent template containers (e.g. `firebase-multi-platform-app`) created.
2. **Metadata Version Accuracy**: The `version:` field in `spec.info.version` of `metadata.yaml` must match the Git Tag being pushed.
3. **Pushed Git Tag**: The Git source tag (e.g. `v12.23.0`) must be fully published to `origin` before you can tell ADC to import it.

## 2. Using `import_adc.sh`
The custom script `modules/terraform-google-firebase/scripts/import_adc.sh` completely automates the `gcloud design-center spaces catalogs templates revisions create` API wrapper.

**Do NOT Run Manual `gcloud design-center` commands for imports.** The script correctly resolves module paths and deletes old revisions automatically, mitigating errors where ADC rejects overwrite attempts.

- Use the exact flags documented in the `.agent/workflows/adc-multi-module-release.md` workflow.
- It supports `--bump-version` and `--commit` for end-to-end automated bumps.

## 3. Review Process
Whenever preparing a release, review the `metadata.yaml` to guarantee that inputs promote efficiently and complex outputs correctly map to `UI elements`.
If structural changes were made to Terraform, the `adc-metadata-preparation.md` workflow MUST be run to regenerate the `varType` properties required by ADC.
