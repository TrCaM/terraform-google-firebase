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

output "service_id" {
  description = "The service ID for which App Check enforcement is enabled."
  value       = google_firebase_app_check_service_config.default.service_id
}

output "play_integrity_config" {
  description = "The configuration for the Play Integrity attestation provider."
  value       = length(google_firebase_app_check_play_integrity_config.default) > 0 ? google_firebase_app_check_play_integrity_config.default[0] : null
}

output "app_attest_config" {
  description = "The configuration for the App Attest attestation provider."
  value       = length(google_firebase_app_check_app_attest_config.default) > 0 ? google_firebase_app_check_app_attest_config.default[0] : null
}

output "device_check_config" {
  description = "The configuration for the Device Check attestation provider."
  value       = length(google_firebase_app_check_device_check_config.default) > 0 ? google_firebase_app_check_device_check_config.default[0] : null
}

output "recaptcha_enterprise_config" {
  description = "The configuration for the reCAPTCHA Enterprise attestation provider."
  value       = length(google_firebase_app_check_recaptcha_enterprise_config.default) > 0 ? google_firebase_app_check_recaptcha_enterprise_config.default[0] : null
}

output "recaptcha_v3_config" {
  description = "The configuration for the reCAPTCHA v3 attestation provider."
  value       = length(google_firebase_app_check_recaptcha_v3_config.default) > 0 ? google_firebase_app_check_recaptcha_v3_config.default[0] : null
}

output "debug_tokens" {
  description = "The configured debug tokens."
  value       = google_firebase_app_check_debug_token.tokens
}

output "project_id" {
  description = "The project ID."
  value       = var.project_id
}
