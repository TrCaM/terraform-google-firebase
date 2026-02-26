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

output "project_id" {
  description = "The project ID."
  value       = var.project_id
}

output "app_ids" {
  description = "Map of platform names to their respective Firebase App IDs."
  value = {
    web     = try(google_firebase_web_app.default[0].app_id, null)
    android = try(google_firebase_android_app.default[0].app_id, null)
    apple   = try(google_firebase_apple_app.default[0].app_id, null)
  }
}

output "web_config" {
  description = "The configuration snippet for the Firebase Web App."
  value       = try(data.google_firebase_web_app_config.default[0], null)
  sensitive   = true
}

output "android_config" {
  description = "The google-services.json content for the Android App."
  value       = try(data.google_firebase_android_app_config.default[0].config_file_contents, null)
  sensitive   = true
}

output "apple_config" {
  description = "The GoogleService-Info.plist content for the Apple App."
  value       = try(data.google_firebase_apple_app_config.default[0].config_file_contents, null)
  sensitive   = true
}

output "app_check_bundle" {
  description = "A structured object containing verified app IDs and metadata tailored for the Firebase App Check module."
  value = {
    android = coalesce(try(var.apps.android_app.register_app_check, false), false) && length(google_firebase_android_app.default) > 0 ? [{
      app_id    = try(google_firebase_android_app.default[0].app_id, null)
      token_ttl = null
    }] : []

    apple = coalesce(try(var.apps.apple_app.register_app_check, false), false) && length(google_firebase_apple_app.default) > 0 ? [{
      app_id     = try(google_firebase_apple_app.default[0].app_id, null)
      token_ttl  = null
      app_attest = try(var.apps.apple_app.team_id, null) != null ? true : null
      device_check = try(var.apps.apple_app.device_check_key, null) != null && try(var.apps.apple_app.device_check_id, null) != null ? {
        private_key = var.apps.apple_app.device_check_key
        key_id      = var.apps.apple_app.device_check_id
      } : null
    }] : []

    web = coalesce(try(var.apps.web_app.register_app_check, false), false) && length(google_firebase_web_app.default) > 0 ? [{
      app_id              = try(google_firebase_web_app.default[0].app_id, null)
      site_key            = try(var.apps.web_app.recaptcha_site_key, null)
      recaptcha_v3_secret = null
      token_ttl           = null
    }] : []
  }
}
