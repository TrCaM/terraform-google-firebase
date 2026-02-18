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
  description = "The project ID."
  type        = string
}

variable "location" {
  description = "The location for the prompt template."
  type        = string
  default     = "global"
}

variable "template_id" {
  description = "The unique identifier for the prompt template."
  type        = string
}

variable "template_string" {
  description = "Direct text input for the prompt template content. Overrides gcs_source if provided."
  type        = string
  default     = null
}

variable "gcs_source" {
  description = "Object containing bucket and name to fetch prompt content from GCS."
  type = object({
    bucket = string
    name   = string
  })
  default = null
}

variable "enable_lock" {
  description = "Whether to create a production lock for the prompt template."
  type        = bool
  default     = false
}
