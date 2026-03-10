# Releasing a New Version (Without ADC Import)

This guide walks through the steps to successfully bump the version of all Firebase modules, commit the changes, and create a GitHub release manually. This allows you to skip the automated `import_adc.sh` script, which intrinsically enforces a push to the App Design Center (ADC).

## 1. Bump Metadata Versions
First, update the `metadata.yaml` for every module to the new version (for example, `12.16.0`). This ensures the module version and local module dependency references are correct.

Run this quick command from the root of the repository:

```bash
# Update the main module version and the local module connections dependency
for f in modules/*/metadata.yaml; do 
  sed -i.bak "s/^    version: .*/    version: 12.16.0/" "$f"
  sed -i.bak "s/^              version: \">= 12\.[0-9]*\.[0-9]*\"/              version: \">= 12.16.0\"/" "$f"
  rm -f "$f.bak"
done
```

## 2. Commit and Push the Version Bumps
Once the metadata files are updated, commit these changes to your `main` branch:

```bash
git add modules/*/metadata.yaml
git commit -m "Bump ADC metadata versions to 12.16.0"
git push origin main
```

## 3. Create the Git Tag
Tags trigger the release process. Create the tag locally and push it to the remote repository:

```bash
git tag v12.16.0
git push origin v12.16.0
```

## 4. Create the GitHub Release
Finally, you need to turn that tag into an official GitHub Release.

### Option A: Using the GitHub CLI (`gh`)
If you have the `gh` CLI installed, run this command to automatically generate release notes and publish the release:

```bash
gh release create v12.16.0 --generate-notes -t "Release v12.16.0"
```

### Option B: Using the GitHub UI
1. Go to your repository on GitHub.
2. Click on **Tags** (usually near the branch dropdown).
3. Find `v12.16.0` and click **Create release from tag**.
4. Click **Generate release notes** (or handle them manually).
5. Click **Publish release**.
