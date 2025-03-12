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

output "allocated_ip" {
  description = "This output represents the IP address that you've allocated for future use. This IP address is unique globally within your GCP project."
  value       = module.network.allocated_ip
}

output "network_id" {
  description = "This output is the unique self_link of the VPC network you've created. This link can be used to reference the network in other Google Cloud resources."
  value       = module.network.network_id
}

output "nodes_subnet_id" {
  description = "This output is the unique self_link of the subnet where the nodes of the GKE cluster will be located. This link can be used to reference the subnet in other Google Cloud resources."
  value       = module.network.nodes_subnet_id
}
