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

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

module "multi_platform_app" {
  source       = "../../modules/firebase_multi_platform_application"
  project_id   = var.project_id
  display_name = "AI Logic Integration App"

  web_app = {}
}

module "ai_logic_core" {
  source     = "../../modules/firebase_ai_logic_core"
  project_id = var.project_id
  location   = var.location
  create_app = false
  app_id     = module.multi_platform_app.app_ids.web

  # Recommended: Explicitly depend on the app module
  depends_on = [module.multi_platform_app]
}

module "ai_logic_template_direct" {
  source      = "../../modules/firebase_ai_logic_prompt_template"
  project_id  = var.project_id
  template_id = "hello-world-direct"

  template_string = <<EOT
---
model: googleai/gemini-1.5-flash
---
Hello from a direct prompt template!
EOT

  depends_on = [module.ai_logic_core]
}

# Example of GCS sourced template
resource "google_storage_bucket" "prompts" {
  name          = "${var.project_id}-ailogic-example-prompts"
  location      = "US"
  force_destroy = true
}

resource "google_storage_bucket_object" "prompt_file" {
  name    = "gcs-prompt.txt"
  bucket  = google_storage_bucket.prompts.name
  content = <<EOT
---
model: googleai/gemini-1.5-flash
---
Hello from GCS content!
EOT
}

module "ai_logic_template_gcs" {
  source      = "../../modules/firebase_ai_logic_prompt_template"
  project_id  = var.project_id
  template_id = "hello-world-gcs"

  gcs_source = {
    bucket = google_storage_bucket.prompts.name
    name   = google_storage_bucket_object.prompt_file.name
  }

  depends_on = [module.ai_logic_core]
}
