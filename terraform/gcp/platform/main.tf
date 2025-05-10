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
  #   TODO change to released gcp-platform
  source = "/Users/andrzej/repo/terraform-gcp-platform/"

  gcp_project_id       = var.gcp_project_id
  gcp_cluster_name     = var.gcp_cluster_name
  gcp_cluster_location = var.gcp_cluster_location
  vpc_network_link     = var.vpc_network_link
  subnet_link          = var.subnet_link
}

locals {
  ingress_controller_nginx_settings_without_static_ip = {
    "controller.replicaCount" : 1
  }
  ingress_controller_nginx_settings_with_static_ip = {
    "controller.service.loadBalancerIP" : var.public_ip_address
    "controller.replicaCount" : 1
  }
  kubeconfig = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${module.cluster.cluster_ca_certificate}
    server: https://${module.cluster.endpoint}
  name: ${var.gcp_cluster_name}
contexts:
- context:
    cluster: ${var.gcp_cluster_name}
    user: ${var.gcp_cluster_name}
  name: ${var.gcp_cluster_name}
current-context: ${var.gcp_cluster_name}
kind: Config
preferences: {}
users:
- name: ${var.gcp_cluster_name}
  user:
    auth-provider:
      config:
        cmd-args: config config-helper --format=json
        cmd-path: gcloud
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp
EOT
}

resource "local_sensitive_file" "kubeconfig" {
  filename = "${path.module}/env/kubeconfig"
  content  = local.kubeconfig
}

module "streamx" {
  source  = "streamx-dev/charts/helm"
  version = "0.0.4"

  cert_manager_lets_encrypt_issuer_acme_email = var.cert_manager_lets_encrypt_issuer_acme_email
  ingress_controller_nginx_settings           = var.public_ip_address == null || var.public_ip_address == "" ? local.ingress_controller_nginx_settings_without_static_ip : local.ingress_controller_nginx_settings_with_static_ip
  pulsar_kaap_values = [file("${path.module}/config/pulsar-kaap/values.yaml")]
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
