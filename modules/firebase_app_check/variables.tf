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
  description = "The project ID to deploy to."
  type        = string
}

variable "service_id" {
  description = "The service ID for which to enable App Check enforcement (e.g., firestore.googleapis.com)."
  type        = string
}

variable "enforcement_mode" {
  description = "The enforcement mode for the service. Default is ENFORCED."
  type        = string
  default     = "ENFORCED"
}

variable "apps" {
  description = "Configurations for apps to be protected by App Check. "
  type = object({
    android = optional(object({
      app_id    = string
      token_ttl = optional(string)
    }))
    apple = optional(object({
      app_id       = string
      token_ttl    = optional(string)
      app_attest   = optional(bool)        # If true, configures App Attest
      device_check = optional(object({    # If provided, configures Device Check
        private_key = string
        key_id      = string
      }))
    }))
    web = optional(object({
      app_id               = string
      site_key             = optional(string) # For reCAPTCHA Enterprise
      recaptcha_v3_secret  = optional(string) # If provided, configures reCAPTCHA v3
      token_ttl            = optional(string)
    }))
  })
  default = {}
}

variable "debug_tokens" {
  description = "List of debug tokens to create for specific apps."
  type = list(object({
    app_id       = string
    display_name = string
    token        = string
  }))
  default = []
}
