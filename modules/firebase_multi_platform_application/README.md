# Firebase Multi-Platform Application Module

This submodule provides a comprehensive bootstrap for a Firebase project, including API enablement, project initialization, and the creation of up to three platform-specific apps (Web, iOS, Android) within a single logical application group.

## Features

- **Automated API Enablement**: Enables `firebase.googleapis.com`, `serviceusage.googleapis.com`, `cloudresourcemanager.googleapis.com`, and `identitytoolkit.googleapis.com`.
- **Project Initialization**: Converts a standard Google Cloud project into a Firebase project.
- **Multi-Platform App Creation**: Register Web, Android, and Apple (iOS) apps simultaneously.
- **Shared Branding**: Uses a single `display_name` across all apps for consistency.
- **Secure Configuration Outputs**: Retrieves and outputs `google-services.json`, `GoogleService-Info.plist`, and Web SDK snippets as sensitive values.

## Usage

```hcl
module "firebase_app" {
  source       = "./modules/firebase_multi_platform_application"
  project_id   = "my-project-id"
  display_name = "My Awesome App"

  web_app = {}

  android_app = {
    package_name = "com.example.app"
  }

  apple_app = {
    bundle_id = "com.example.app"
  }
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apps | Configuration for Firebase apps. | <pre>object({<br>    web_app = optional(object({<br>      display_name       = optional(string)<br>      api_key_id         = optional(string)<br>      enable_app_check   = optional(bool, false)<br>      recaptcha_site_key = optional(string)<br>    }))<br>    android_app = optional(object({<br>      package_name     = optional(string)<br>      display_name     = optional(string)<br>      sha256_hashes    = optional(list(string))<br>      enable_app_check = optional(bool, false)<br>    }))<br>    apple_app = optional(object({<br>      bundle_id        = optional(string)<br>      display_name     = optional(string)<br>      team_id          = optional(string)<br>      enable_app_check = optional(bool, false)<br>      device_check_key = optional(string)<br>      device_check_id  = optional(string)<br>    }))<br>  })</pre> | `{}` | no |
| project\_id | The GCP project ID to initialize Firebase in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| android\_config | The google-services.json content for the Android App. |
| app\_check\_bundle | A structured object containing verified app IDs and metadata tailored for the Firebase App Check module. |
| app\_ids | Map of platform names to their respective Firebase App IDs. |
| ios\_config | The GoogleService-Info.plist content for the Apple App. |
| project\_id | The project ID. |
| web\_config | The configuration snippet for the Firebase Web App. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
