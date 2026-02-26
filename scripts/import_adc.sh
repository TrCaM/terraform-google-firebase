#!/bin/bash
# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# Default values
LOCATION="us-central1"
SPACE="default-space"
CATALOG="default-catalog"
MODULES="firebase_multi_platform_application,firebase_app_check,firebase_auth"
REPO="TrCaM/terraform-google-firebase"

# Display usage
function show_usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --project <project_id>   (Required) GCP Project ID for ADC"
    echo "  --revision <revision>    (Required) The revision name to create in ADC (e.g., r3)"
    echo "  --tag <tag>              (Required) The Git tag to import from (e.g., v12.15.0)"
    echo "  --publish-tag            If provided, creates an annotated local tag and pushes to origin before importing."
    echo "  --location <location>    (Optional) ADC Location (default: $LOCATION)"
    echo "  --space <space>          (Optional) ADC Space (default: $SPACE)"
    echo "  --catalog <catalog>      (Optional) ADC Catalog (default: $CATALOG)"
    echo "  --repo <repo>            (Optional) The Git repository path (default: $REPO)"
    echo "  --modules <modules>      (Optional) Comma-separated list of modules to import."
    echo "                           (default: $MODULES)"
    echo "  -h, --help               Shows this help message"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --project) PROJECT="$2"; shift 2 ;;
        --revision) REVISION="$2"; shift 2 ;;
        --tag) TAG="$2"; shift 2 ;;
        --publish-tag) PUBLISH_TAG=1; shift 1 ;;
        --location) LOCATION="$2"; shift 2 ;;
        --space) SPACE="$2"; shift 2 ;;
        --catalog) CATALOG="$2"; shift 2 ;;
        --repo) REPO="$2"; shift 2 ;;
        --modules) MODULES="$2"; shift 2 ;;
        -h|--help) show_usage; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_usage; exit 1 ;;
    esac
done

# Validate required arguments
if [[ -z "$PROJECT" || -z "$REVISION" || -z "$TAG" ]]; then
    echo "Error: --project, --revision, and --tag are required."
    show_usage
    exit 1
fi

echo "=========================================="
echo " ADC Import Configuration"
echo "=========================================="
echo " Project:     $PROJECT"
echo " Location:    $LOCATION"
echo " Space:       $SPACE"
echo " Catalog:     $CATALOG"
echo " Revision:    $REVISION"
echo " Tag:         $TAG"
echo " Publish Tag: ${PUBLISH_TAG:-0}"
echo " Repository:  $REPO"
echo " Modules:     $MODULES"
echo "=========================================="
echo ""

# Handle tag publishing
if [[ "$PUBLISH_TAG" == "1" ]]; then
    echo "Publishing tag: $TAG..."
    git tag "$TAG" || { echo "Failed to create local tag. Ensure it does not already exist."; exit 1; }
    git push origin "$TAG" || { echo "Failed to push tag."; exit 1; }
    echo "Successfully pushed tag $TAG."
    echo ""
fi

# Convert comma-separated modules into an array
IFS=',' read -r -a MODULE_ARRAY <<< "$MODULES"

for DIR in "${MODULE_ARRAY[@]}"; do
    # Map directory to ADC template name
    TEMPLATE=""
    case $DIR in
        "firebase_multi_platform_application") TEMPLATE="firebase-multi-platform-app" ;;
        "firebase_app_check") TEMPLATE="terraform-google-firebase-app-check" ;;
        "firebase_auth") TEMPLATE="terraform-google-firebase-firebase-auth" ;;
        *) echo "Skipping unknown module: $DIR"; continue ;;
    esac

    echo "------------------------------------------"
    echo "Importing directory '$DIR' as template '$TEMPLATE'..."
    echo "------------------------------------------"

    # Delete existing revision if any
    echo "Deleting existing revision '$REVISION' (if it exists)..."
    gcloud design-center spaces catalogs templates revisions delete "$REVISION" \
        --project="$PROJECT" \
        --location="$LOCATION" \
        --space="$SPACE" \
        --catalog="$CATALOG" \
        --template="$TEMPLATE" \
        --quiet || echo "Revision did not exist or could not be deleted."

    # Create new revision
    echo "Creating new revision '$REVISION' from tag '$TAG'..."
    gcloud design-center spaces catalogs templates revisions create "$REVISION" \
        --project="$PROJECT" \
        --location="$LOCATION" \
        --space="$SPACE" \
        --catalog="$CATALOG" \
        --template="$TEMPLATE" \
        --git-source-repo="$REPO" \
        --git-source-ref-tag="$TAG" \
        --git-source-dir="modules/$DIR"

    echo "Completed import for '$TEMPLATE'."
    echo ""
done

echo "=========================================="
echo " ADC Import Complete!"
echo "=========================================="
