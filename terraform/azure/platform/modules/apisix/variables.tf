# Copyright 2025 Dynamic Solutions Sp. z o.o. sp.k.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

variable "force_defaults_for_null_variables" {
  default     = true
  description = "Enables forcing default variable values when the variable value passed to the module is null."
  type        = bool
}

variable "atomic" {
  default     = true
  description = "Purge the chart on a failed installation. Default's to \"true\"."
  type        = bool
}

variable "chart_name" {
  default     = "apisix-ingress-controller"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "chart_repository" {
  default     = "https://charts.apiseven.com"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "chart_version" {
  default     = "0.14.0"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "create_namespace" {
  default     = true
  description = "Create a namespace for the deployment. Defaults to \"true\"."
  type        = bool
}

variable "namespace" {
  default     = "ingress-apisix"
  description = "The namespace used for the deployment"
  type        = string
}

variable "release_name" {
  default     = "apisix"
  description = "The name of the helm release"
  type        = string
}

variable "settings" {
  default     = {}
  description = "Settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "timeout" {
  default     = 480
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "values" {
  default     = []
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}
