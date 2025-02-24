module "azure_platform" {
  source  = "streamx-dev/platform/azurerm"
  version = "0.0.2"

  resource_group_enabled = false
  cluster_name           = var.cluster_name
  location               = var.location
  resources_group_name   = var.resource_group_name
  kubeconfig_path        = "${path.module}/.env/kubeconfig"
  user_identity_id       = var.user_identity_id
  public_ip_id           = var.public_ip_id
}

locals {
  ingress_controller_nginx_settings_without_static_ip = {
    "controller.replicaCount" : 1
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path" : "/healthz"
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal" : false
  }
  ingress_controller_nginx_settings_with_static_ip = {
    "controller.service.loadBalancerIP" : var.public_ip_address
    "controller.replicaCount" : 1
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group" : var.resource_group_name
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path" : "/healthz"
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal" : false
  }
}

module "apisix" {
  source = "./modules/apisix"

  values = [
    file("${path.module}/config/gateway/values.yaml")
  ]

  settings = var.public_ip_address != null && var.public_ip_address != "" ? {
    "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group" : var.resource_group_name
    "service.loadBalancerIP" : var.public_ip_address
  } : {}
}

module "streamx" {
  source  = "streamx-dev/charts/helm"
  version = "0.0.3"

  ingress_controller_nginx_enabled                         = false
  cert_manager_lets_encrypt_issuer_acme_email              = var.cert_manager_lets_encrypt_issuer_acme_email
  cert_manager_lets_encrypt_issuer_prod_letsencrypt_server = var.cert_manager_lets_encrypt_issuer_prod_letsencrypt_server
  cert_manager_lets_encrypt_issuer_ingress_class           = "apisix"
  pulsar_kaap_values = [
    file("${path.module}/config/pulsar-kaap/values.yaml")
  ]
  streamx_operator_image_pull_secret_registry_email    = var.streamx_operator_image_pull_secret_registry_email
  streamx_operator_image_pull_secret_registry_password = var.streamx_operator_image_pull_secret_registry_password
  streamx_operator_chart_repository_username           = "_json_key_base64"
  streamx_operator_chart_repository_password           = var.streamx_operator_image_pull_secret_registry_password
}