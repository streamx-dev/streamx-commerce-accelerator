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


output "floatingip" {
  description = "Allocated floating IP for future usage"
  value       = module.tf_network.floatingip
}

output "nodes_subnet_id" {
  description = "Nodes subnet ID"
  value       = module.tf_network.nodes_subnet_id
}

output "network_id" {
  description = "Network id to attach cluster"
  value       = module.tf_network.network_id
}

