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

module "auth_core" {
  source = "../../modules/firebase_auth_core"

  project_id             = var.project_id
  email_enabled          = true
  anonymous_enabled      = true
  allow_duplicate_emails = false
}

module "auth_google" {
  source = "../../modules/firebase_auth_google"

  project_id    = module.auth_core.project_id
  client_id     = var.google_client_id
  client_secret = var.google_client_secret
}

module "auth_facebook" {
  source = "../../modules/firebase_auth_facebook"

  project_id          = module.auth_core.project_id
  facebook_app_id     = var.facebook_app_id
  facebook_app_secret = var.facebook_app_secret
}

module "auth_github" {
  source = "../../modules/firebase_auth_github"

  project_id    = module.auth_core.project_id
  client_id     = var.github_client_id
  client_secret = var.github_client_secret
}

module "auth_apple" {
  source = "../../modules/firebase_auth_apple"

  project_id    = module.auth_core.project_id
  service_id    = var.apple_service_id
  team_id       = var.apple_team_id
  key_id        = var.apple_key_id
  client_secret = var.apple_client_secret
}
