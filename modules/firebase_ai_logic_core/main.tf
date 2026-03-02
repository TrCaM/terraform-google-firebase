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
  app_parts = split(":", var.app_id)
  platform  = length(local.app_parts) >= 3 ? local.app_parts[2] : null

  is_web     = local.platform == "web"
  is_android = local.platform == "android"
  is_apple   = local.platform == "ios"
}

# 1. Verification of existing app
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

# 2. Enable Required APIs
resource "google_project_service" "vertexai" {
  count              = var.api_config.vertex_ai ? 1 : 0
  provider           = google-beta
  project            = var.project_id
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "gemini" {
  count              = var.api_config.gemini_developer ? 1 : 0
  provider           = google-beta
  project            = var.project_id
  service            = "generativelanguage.googleapis.com"
  disable_on_destroy = false
}

# 3. Generate Gemini API Key (if enabled)
resource "google_apikeys_key" "gemini" {
  count        = var.api_config.gemini_developer ? 1 : 0
  provider     = google-beta
  project      = var.project_id
  name         = "firebase-ai-logic-gemini-key"
  display_name = "Gemini API Key for Firebase AI Logic"

  restrictions {
    api_targets {
      service = "generativelanguage.googleapis.com"
    }
  }

  depends_on = [google_project_service.gemini]
}

# 4. AI Logic Configuration
resource "google_firebase_ai_logic_config" "default" {
  provider = google-beta
  project  = var.project_id
  location = var.location

  dynamic "generative_language_config" {
    for_each = var.api_config.gemini_developer ? [1] : []
    content {
      api_key = google_apikeys_key.gemini[0].key_string
    }
  }

  telemetry_config {
    mode          = var.telemetry_mode
    sampling_rate = var.telemetry_sampling_rate
  }

  depends_on = [
    data.google_firebase_web_app.provided,
    data.google_firebase_android_app.provided,
    data.google_firebase_apple_app.provided
  ]
}
