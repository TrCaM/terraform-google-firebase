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

# Base Identity Platform Configuration (Singleton)
resource "google_identity_platform_config" "auth" {
  provider = google-beta
  project  = var.project_id

  sign_in {
    allow_duplicate_emails = var.allow_duplicate_emails

    anonymous {
      enabled = var.anonymous_enabled
    }

    email {
      enabled           = var.email_enabled
      password_required = var.email_password_required
    }

    phone_number {
      enabled            = var.phone_enabled
      test_phone_numbers = var.test_phone_numbers
    }
  }

  autodelete_anonymous_users = true

  multi_tenant {
    allow_tenants = var.multi_tenancy_enabled
  }
}
