# releasing/terraform-google-firebase/terraform-google-firebase

This module makes it easy to manage Firebase resources on Google Cloud Platform, following the Cloud Foundation Toolkit (CFT) standards.

This module consists of the following submodules:

- [firebase_core](./modules/firebase_core)
- [firebase_apps](./modules/firebase_apps)
- [firebase_rules](./modules/firebase_rules)
- [firebase_ai_logic](./modules/firebase_ai_logic)
- [firebase_auth](./modules/firebase_auth)
- [firebase_app_check](./modules/firebase_app_check)
- [firebase_app_hosting](./modules/firebase_app_hosting)

See more details in each module's README.

## Compatibility
This module is meant for use with Terraform 1.3+ and tested using Terraform 1.6+.
If you find incompatibilities using Terraform `>=1.13`, please open an issue.

## Root module

The root module has no configuration. Please switch to using one of the submodules.

## Requirements

### Installation Dependencies

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v5.0+
- [Terraform Provider Beta for GCP](https://github.com/terraform-providers/terraform-provider-google-beta) plugin v5.0+

### Configure a Service Account

> [!CAUTION]
> **TODO**: Finalize the minimum required roles for comprehensive Firebase management.

In order to execute this module you must have a Service Account.

#### Roles

No specific roles are required at this stage. Roles will be documented here as they are identified.

### Enable APIs

> [!CAUTION]
> **TODO**: Verify the full list of required APIs for all Wave 1 products.

No specific APIs are required at this stage. APIs will be documented here as they are identified.

## Provision Instructions

> [!CAUTION]
> **TODO**: Update these examples with real resource configurations once submodules are finalized.

This module has no root configuration. A module with no root configuration cannot be used directly.

Copy and paste into your Terraform configuration, insert the variables, and run terraform init :

For General Firebase Configuration:
```hcl
module "firebase" {
  source  = "terraform-google-modules/firebase/google//modules/firebase_core"
  version = "~> 0.1"

  project_id = "<PROJECT ID>"
}
```

For Firebase Apps:
```hcl
module "firebase_apps" {
  source  = "terraform-google-modules/firebase/google//modules/firebase_apps"
  version = "~> 0.1"

  project_id = "<PROJECT ID>"
}
```

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
