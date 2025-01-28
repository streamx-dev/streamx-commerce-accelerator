module "azure_platform" {
  source  = "streamx-dev/platform/azurerm"
  version = "0.0.1"

  resource_group_enabled = false
  cluster_name           = var.cluster_name
  location               = var.location
  resources_group_name   = var.resources_group_name
  kubeconfig_path        = "${path.module}/.env/kubeconfig"
}

module "streamx" {
  source  = "streamx-dev/charts/helm"
  version = "0.0.1"

  cert_manager_lets_encrypt_issuer_acme_email = var.cert_manager_lets_encrypt_issuer_acme_email
  ingress_controller_nginx_settings = {
    "controller.replicaCount" : 1
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path" : "/healthz"
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal" : false
  }
  pulsar_kaap_values = [
    file("${path.module}/config/pulsar-kaap/values.yaml")
  ]
  streamx_operator_image_pull_secret_registry_email    = var.streamx_operator_image_pull_secret_registry_email
  streamx_operator_image_pull_secret_registry_password = var.streamx_operator_image_pull_secret_registry_password
  streamx_operator_chart_repository_username           = "_json_key_base64"
  streamx_operator_chart_repository_password           = var.streamx_operator_image_pull_secret_registry_password
}
