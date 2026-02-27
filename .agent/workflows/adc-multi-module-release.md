---
description: Automatically import the 3 core Firebase modules to ADC.
---

# ADC Multi-Module Release Workflow

This workflow performs a coordinated release of the three core Firebase modules (`firebase_multi_platform_application`, `firebase_app_check`, `firebase_auth`) by tagging the repository (if not already done) and creating new minor revisions in App Design Center (ADC).

## Pre-requisites
Ensure the target GCP Project has the template containers created for the modules. If not, create them first:
```bash
# E.g., gcloud design-center spaces catalogs templates create [TEMPLATE-ID] --project=[PROJECT] etc.
```

## Execution Steps

Run the following command to perform the release. 
> **Note to Agent**: Before running this automatically, verify the current version in `metadata.yaml`.

# IMPORTANT: ADC does not support overwriting revisions. The script automatically handles deleting the old revision first if it already exists.
# REPLACE `[PROJECT]` WITH THE CORRECT PROJECT ID
# REPLACE `[REVISION]` WITH THE CORRECT REVISION NAME (e.g. `r1`)
# REPLACE `[TAG]` WITH THE NEW TAG NAME (e.g. `v12.23.0`)
# Include `--bump-version`, `--commit`, and `--publish-tag` flags if you are making a completely new release rather than importing an existing tag.
./scripts/import_adc.sh \
  --project "[PROJECT]" \
  --revision "[REVISION]" \
  --tag "[TAG]"
