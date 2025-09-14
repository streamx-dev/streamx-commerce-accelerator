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


module "cluster" {
  source = "/Users/andrzej/repo/terraform-ovh-platform/modules/cluster"
  service_name            = var.service_name
  kubeconfig_path        = "${path.module}/.env/kubeconfig"
  network_id = var.public_ip_address == null || var.public_ip_address == "" ? null: var.network_id
  nodes_subnet_id = var.public_ip_address == null || var.public_ip_address == "" ? null: var.nodes_subnet_id
  region = var.region
}

locals {
  ingress_controller_nginx_settings_without_static_ip = {
    "controller.replicaCount" : 1
    "controller.service.annotations.loadbalancer\\.ovhcloud\\.com/class" : "octavia"
  }
  ingress_controller_nginx_settings_with_static_ip = {
    "controller.service.loadBalancerIP" : var.public_ip_address
    "controller.replicaCount" : 1
    "controller.service.annotations.loadbalancer\\.ovhcloud\\.com/class" : "octavia"
  }
}

module "streamx" {
  source  = "streamx-dev/charts/helm"
  version = "0.0.4"

  cert_manager_lets_encrypt_issuer_acme_email = var.cert_manager_lets_encrypt_issuer_acme_email
  ingress_controller_nginx_settings           = var.public_ip_address == null || var.public_ip_address == "" ? local.ingress_controller_nginx_settings_without_static_ip : local.ingress_controller_nginx_settings_with_static_ip
  pulsar_kaap_values = [
    file("${path.module}/config/pulsar-kaap/values.yaml")
  ]
  streamx_operator_image_pull_secret_registry_email    = var.streamx_operator_image_pull_secret_registry_email
  streamx_operator_image_pull_secret_registry_password = var.streamx_operator_image_pull_secret_registry_password
  streamx_operator_chart_repository_username           = "_json_key_base64"
  streamx_operator_chart_repository_password           = var.streamx_operator_image_pull_secret_registry_password
  ingress_controller_nginx_timeout = 300
  cert_manager_timeout = 300
  pulsar_kaap_timeout = 300
  streamx_operator_timeout = 300
  depends_on = [module.cluster]
}