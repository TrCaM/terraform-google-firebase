# ADC Import Guide for Firebase Modules

This guide provides step-by-step instructions on how to import the Terraform Firebase modules into your Google Cloud App Design Center (ADC).

## Prerequisites
1.  **Google Cloud Project**: You need an active GCP project with the App Design Center API (`designcenter.googleapis.com`) enabled.
2.  **Cloud Shell**: It is recommended to run these commands in [Google Cloud Shell](https://console.cloud.google.com/home/dashboard?cloudshell=true) to ensure you have an authenticated `gcloud` environment with the necessary permissions.

## Step 1: Clone the Repository

Open your Cloud Shell terminal and clone the repository:

```bash
git clone https://github.com/TrCaM/terraform-google-firebase.git
cd terraform-google-firebase
```

## Step 2: Set Environment Variables

Replace `YOUR_PROJECT_ID` with your actual GCP Project ID.

By default, the script and `gcloud` commands assume the use of `us-central1` for location and `default-space`/`default-catalog` for its hierarchy. Update these variables if your ADC configuration differs.

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
export LOCATION="us-central1"
export SPACE="default-space"
export CATALOG="default-catalog"
```

## Step 3: Create ADC Template Containers

Before importing the module code, you must create empty template containers in your catalog. Run the following commands:

```bash
# 1. Firebase Multi-Platform App
gcloud design-center spaces catalogs templates create firebase-multi-platform-app \
  --project="$PROJECT_ID" \
  --location="$LOCATION" \
  --space="$SPACE" \
  --catalog="$CATALOG" \
  --display-name="Firebase Multi-Platform Application" \
  --template-category="COMPONENT_TEMPLATE"

# 2. Firebase App Check
gcloud design-center spaces catalogs templates create terraform-google-firebase-app-check \
  --project="$PROJECT_ID" \
  --location="$LOCATION" \
  --space="$SPACE" \
  --catalog="$CATALOG" \
  --display-name="Firebase App Check" \
  --template-category="COMPONENT_TEMPLATE"

# 3. Firebase Authentication
gcloud design-center spaces catalogs templates create terraform-google-firebase-firebase-auth \
  --project="$PROJECT_ID" \
  --location="$LOCATION" \
  --space="$SPACE" \
  --catalog="$CATALOG" \
  --display-name="Firebase Authentication" \
  --template-category="COMPONENT_TEMPLATE"

# 4. Firebase AI Logic Core
gcloud design-center spaces catalogs templates create firebase-firebase-ai-logic-core \
  --project="$PROJECT_ID" \
  --location="$LOCATION" \
  --space="$SPACE" \
  --catalog="$CATALOG" \
  --display-name="Firebase AI Logic Core" \
  --template-category="COMPONENT_TEMPLATE"

# 5. Firebase AI Logic Prompt Template
gcloud design-center spaces catalogs templates create firebase-firebase-ai-logic-prompt-template \
  --project="$PROJECT_ID" \
  --location="$LOCATION" \
  --space="$SPACE" \
  --catalog="$CATALOG" \
  --display-name="Firebase AI Logic Prompt Template" \
  --template-category="COMPONENT_TEMPLATE"
```

## Step 4: Run the Import Script

Once the template containers are created, use the provided `import_adc.sh` script to import the latest version of the modules (e.g., `v12.26.0`) into your ADC templates.

Run the following command, specifying the revision name (e.g., `r9`) and the Git tag you want to import (`v12.26.0`):

```bash
./scripts/import_adc.sh \
  --project "$PROJECT_ID" \
  --location "$LOCATION" \
  --space "$SPACE" \
  --catalog "$CATALOG" \
  --revision "r9" \
  --tag "v12.26.0"
```

> **Note**: The script handles all 5 core modules automatically. It will use the configuration specified in the flags to associate the code from the Git repository with the ADC templates you created in Step 3.
