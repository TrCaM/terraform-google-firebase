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

locals {
  # Parse platform from app_id (format: 1:PROJECT_NUMBER:PLATFORM:APP_ID)
  # Default to null if app_id is not provided or if verification is disabled
  app_parts = (var.verify_app && var.app_id != null) ? split(":", var.app_id) : []
  platform  = length(local.app_parts) >= 3 ? local.app_parts[2] : null

  is_web     = local.platform == "web"
  is_android = local.platform == "android"
  is_apple   = local.platform == "ios"
}

# 1. Verification of existing app (Opt-in via verify_app)
data "google_firebase_web_app" "provided" {
  count    = local.is_web ? 1 : 0
  provider = google-beta
  project  = var.project_id
  app_id   = var.app_id
}

data "google_firebase_android_app" "provided" {
  count    = local.is_android ? 1 : 0
  provider = google-beta
  project  = var.project_id
  app_id   = var.app_id
}

data "google_firebase_apple_app" "provided" {
  count    = local.is_apple ? 1 : 0
  provider = google-beta
  project  = var.project_id
  app_id   = var.app_id
}

# 2. Automatic creation of a default app (Opt-in via create_app)
resource "google_firebase_web_app" "default" {
  count           = var.create_app ? 1 : 0
  provider        = google-beta
  project         = var.project_id
  display_name    = "AI Logic Default App"
  deletion_policy = "DELETE"
}

# 3. AI Logic Configuration (depends on app existence)
resource "google_firebase_ai_logic_config" "default" {
  provider = google-beta
  project  = var.project_id
  location = var.location

  dynamic "generative_language_config" {
    for_each = var.api_key != null ? [1] : []
    content {
      api_key = var.api_key
    }
  }

  telemetry_config {
    mode          = var.telemetry_mode
    sampling_rate = var.telemetry_sampling_rate
  }

  # Ensure AI Logic is enabled only after an app is verified or created
  depends_on = [
    data.google_firebase_web_app.provided,
    data.google_firebase_android_app.provided,
    data.google_firebase_apple_app.provided,
    google_firebase_web_app.default
  ]
}
