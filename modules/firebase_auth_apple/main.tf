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

# Apple IDP Configuration
resource "google_identity_platform_default_supported_idp_config" "apple" {
  provider  = google-beta
  project   = var.project_id
  idp_id    = "apple.com"
  enabled   = true
  client_id = var.service_id
  client_secret = jsonencode({
    teamId     = var.team_id
    keyId      = var.key_id
    privateKey = var.client_secret
  })
}
