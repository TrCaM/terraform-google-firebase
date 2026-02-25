/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The GCP project ID to initialize Firebase in."
  type        = string
}

variable "apps" {
  description = "Configuration for Firebase apps."
  type = object({
    web_app = optional(object({
      display_name       = optional(string)
      api_key_id         = optional(string)
      enable_app_check   = optional(bool)
      recaptcha_site_key = optional(string)
    }))
    android_app = optional(object({
      package_name     = optional(string)
      display_name     = optional(string)
      sha256_hashes    = optional(list(string))
      enable_app_check = optional(bool)
    }))
    apple_app = optional(object({
      bundle_id        = optional(string)
      display_name     = optional(string)
      team_id          = optional(string)
      enable_app_check = optional(bool)
      device_check_key = optional(string)
      device_check_id  = optional(string)
    }))
  })
  default = {}

  validation {
    condition     = var.apps.web_app == null || try(var.apps.web_app.enable_app_check, false) == false || try(var.apps.web_app.recaptcha_site_key, null) != null
    error_message = "If App Check is enabled for the Web App, 'recaptcha_site_key' must be provided."
  }

  validation {
    condition     = var.apps.android_app == null || try(var.apps.android_app.enable_app_check, false) == false || length(try(var.apps.android_app.sha256_hashes, [])) > 0
    error_message = "If App Check is enabled for the Android App, at least one 'sha256_hashes' value must be provided."
  }

  validation {
    condition     = var.apps.apple_app == null || try(var.apps.apple_app.enable_app_check, false) == false || try(var.apps.apple_app.team_id, null) != null
    error_message = "If App Check is enabled for the Apple App, 'team_id' must be provided."
  }
}
