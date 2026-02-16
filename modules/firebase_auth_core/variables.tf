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
  description = "The project ID to deploy to"
  type        = string
}

variable "email_enabled" {
  description = "Whether to enable Email/Password sign-in"
  type        = bool
  default     = false
}

variable "email_password_required" {
  description = "Whether a password is required for email sign-in. If false, email link sign-in is enabled."
  type        = bool
  default     = true
}

variable "phone_enabled" {
  description = "Whether to enable Phone number sign-in"
  type        = bool
  default     = false
}

variable "test_phone_numbers" {
  description = "Map of test phone numbers to their verification codes (e.g., '+16505551234' = '123456')"
  type        = map(string)
  default     = {}
}

variable "anonymous_enabled" {
  description = "Whether to enable Anonymous sign-in"
  type        = bool
  default     = false
}

variable "allow_duplicate_emails" {
  description = "Whether to allow multiple accounts with the same email address"
  type        = bool
  default     = false
}

variable "multi_tenancy_enabled" {
  description = "Whether to enable multi-tenancy for the Identity Platform configuration. If null, the block is omitted (but may cause drift if the API returns a default)."
  type        = bool
  default     = false
}
