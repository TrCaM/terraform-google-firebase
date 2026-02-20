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

# Service Enforcement
resource "google_firebase_app_check_service_config" "services" {
  provider         = google-beta
  project          = var.project_id
  service_id       = var.service_id
  enforcement_mode = var.enforcement_mode
}

# Play Integrity (Android)
resource "google_firebase_app_check_play_integrity_config" "default" {
  count     = var.apps.android != null ? 1 : 0
  provider  = google-beta
  project   = var.project_id
  app_id    = var.apps.android.app_id
  token_ttl = var.apps.android.token_ttl
}

# App Attest (Apple)
resource "google_firebase_app_check_app_attest_config" "default" {
  count     = (var.apps.apple != null && try(var.apps.apple.app_attest, false) == true) ? 1 : 0
  provider  = google-beta
  project   = var.project_id
  app_id    = var.apps.apple.app_id
  token_ttl = var.apps.apple.token_ttl
}

# Device Check (Apple)
resource "google_firebase_app_check_device_check_config" "default" {
  count       = (var.apps.apple != null && var.apps.apple.device_check != null) ? 1 : 0
  provider    = google-beta
  project     = var.project_id
  app_id      = var.apps.apple.app_id
  private_key = var.apps.apple.device_check.private_key
  key_id      = var.apps.apple.device_check.key_id
  token_ttl   = var.apps.apple.token_ttl
}

# reCAPTCHA Enterprise (Web)
resource "google_firebase_app_check_recaptcha_enterprise_config" "default" {
  count    = (var.apps.web != null && var.apps.web.site_key != null) ? 1 : 0
  provider = google-beta
  project  = var.project_id
  app_id   = var.apps.web.app_id
  site_key = var.apps.web.site_key
}

# reCAPTCHA v3 (Web)
resource "google_firebase_app_check_recaptcha_v3_config" "default" {
  count       = (var.apps.web != null && var.apps.web.recaptcha_v3_secret != null) ? 1 : 0
  provider    = google-beta
  project     = var.project_id
  app_id      = var.apps.web.app_id
  site_secret = var.apps.web.recaptcha_v3_secret
  token_ttl   = var.apps.web.token_ttl
}

# Debug Tokens
resource "google_firebase_app_check_debug_token" "tokens" {
  for_each     = { for token in var.debug_tokens : "${token.app_id}-${token.display_name}" => token }
  provider     = google-beta
  project      = var.project_id
  app_id       = each.value.app_id
  display_name = each.value.display_name
  token        = each.value.token
}
