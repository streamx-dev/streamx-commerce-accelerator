module "azure_platform" {
  source  = "streamx-dev/platform/azurerm"
  version = "0.0.2"

  resource_group_enabled               = false
  cluster_name                         = var.cluster_name
  cluster_default_node_pool_vm_size    = "Standard_D3_v2"
  cluster_default_node_pool_node_count = 3
  location                             = var.location
  resources_group_name                 = var.resource_group_name
  kubeconfig_path                      = "${path.module}/.env/kubeconfig"
  user_identity_id                     = var.user_identity_id
  public_ip_id                         = var.public_ip_id
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

module "monitoring_tempo" {
  source                            = "./modules/monitoring-tempo"
  monitoring_storage_container_name = var.monitoring_storage_container_name
  monitoring_storage_account_name   = var.monitoring_storage_account_name
  monitoring_storage_access_key     = var.monitoring_storage_access_key
}

module "monitoring_loki" {
  source                            = "./modules/monitoring-loki"
  monitoring_storage_container_name = var.monitoring_storage_container_name
  monitoring_storage_account_name   = var.monitoring_storage_account_name
  monitoring_storage_access_key     = var.monitoring_storage_access_key
}

module "streamx" {
  source = "/Users/marekczajkowski/workspace/terraform-helm-charts"
  #source  = "streamx-dev/charts/helm"
  #version = "0.0.4"

  ingress_controller_nginx_enabled                         = false
  cert_manager_lets_encrypt_issuer_acme_email              = var.cert_manager_lets_encrypt_issuer_acme_email
  cert_manager_lets_encrypt_issuer_prod_letsencrypt_server = var.cert_manager_lets_encrypt_issuer_prod_letsencrypt_server
  cert_manager_lets_encrypt_issuer_ingress_class           = "apisix"
  pulsar_kaap_values = [
    file("${path.module}/config/pulsar-kaap/values-${var.streamx_environment_size}.yaml")
  ]
  streamx_operator_image_pull_secret_registry_email    = var.streamx_operator_image_pull_secret_registry_email
  streamx_operator_image_pull_secret_registry_password = var.streamx_operator_image_pull_secret_registry_password
  streamx_operator_chart_repository_username           = "_json_key_base64"
  streamx_operator_chart_repository_password           = var.streamx_operator_image_pull_secret_registry_password

  tempo_create_namespace = false
  tempo_values = [
    file("${path.module}/config/monitoring/tempo/values.yaml")
  ]

  loki_create_namespace = false
  loki_values = [
    file("${path.module}/config/monitoring/loki/values.yaml")
  ]

  minio_enabled = false

}