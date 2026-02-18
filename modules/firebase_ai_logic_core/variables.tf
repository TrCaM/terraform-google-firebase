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

variable "location" {
  description = "The location for the AI Logic configuration."
  type        = string
  default     = "global"
}

variable "app_id" {
  description = "The App ID for a Firebase app in the project. Required if create_app is false."
  type        = string
  default     = null
}

variable "create_app" {
  description = "Whether to create a default Firebase Web App if no app_id is provided."
  type        = bool
  default     = true
}

variable "verify_app" {
  description = "Whether to verify the existence of the provided app_id using a data source. Opt-in recommended only for non-computed app IDs."
  type        = bool
  default     = false
}

variable "api_key" {
  description = "The Gemini API key for server-side configuration."
  type        = string
  default     = null
  sensitive   = true
}

variable "telemetry_mode" {
  description = "Telemetry mode for AI Logic (e.g., ALL, NONE)."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["ALL", "NONE"], var.telemetry_mode)
    error_message = "The telemetry_mode must be one of: ALL, NONE."
  }
}

variable "telemetry_sampling_rate" {
  description = "Sampling rate for telemetry."
  type        = number
  default     = 1.0

  validation {
    condition     = var.telemetry_sampling_rate >= 0.0 && var.telemetry_sampling_rate <= 1.0
    error_message = "The telemetry_sampling_rate must be between 0.0 and 1.0."
  }
}
