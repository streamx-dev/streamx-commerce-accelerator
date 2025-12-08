locals {
  vm_sizes = {
    small  = "Standard_D3_v2"
    medium = "Standard_D4_v2"
    large  = "Standard_D5_v2"
  }

  grafana_host_provided = var.monitoring_grafana_host != null && var.monitoring_grafana_host != "" ? true : false
}


module "azure_platform" {
  source  = "streamx-dev/platform/azurerm"
  version = "0.0.4"

  resource_group_enabled                   = false
  cluster_name                             = var.cluster_name
  cluster_default_node_pool_vm_size        = local.vm_sizes[var.streamx_environment_size]
  cluster_default_node_pool_node_count     = 3
  cluster_default_node_pool_node_max_count = 5

  location             = var.location
  resources_group_name = var.resource_group_name
  kubeconfig_path      = "${path.module}/.env/kubeconfig"
  user_identity_id     = var.user_identity_id
  public_ip_id         = var.public_ip_id
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

  depends_on = [module.azure_platform]
}

module "grafana_secret" {
  count = local.grafana_host_provided ? 1 : 0

  source           = "./modules/secret-init"
  create_namespace = true
  namespace        = "prometheus-stack"
  secret_name      = var.monitoring_grafana_secret_name
  secret_file      = "${path.module}/../../../gateway/tls/${var.monitoring_grafana_secret_name}.yaml"
  depends_on       = [module.azure_platform]
}

module "streamx" {
  source  = "streamx-dev/charts/helm"
  version = "0.1.3-fix1"

  ingress_controller_nginx_enabled                         = false
  cert_manager_lets_encrypt_issuer_acme_email              = var.cert_manager_lets_encrypt_issuer_acme_email
  cert_manager_lets_encrypt_issuer_prod_letsencrypt_server = var.cert_manager_lets_encrypt_issuer_prod_letsencrypt_server
  cert_manager_lets_encrypt_issuer_ingress_class           = "apisix"
  pulsar_kaap_values = [
    file("${path.module}/config/pulsar-kaap/values.yaml")
  ]
  pulsar_resources_operator_chart_version = "0.13.0"

  streamx_operator_chart_version                       = "0.1.8"
  streamx_operator_image_pull_secret_registry_email    = var.streamx_operator_image_pull_secret_registry_email
  streamx_operator_image_pull_secret_registry_password = var.streamx_operator_image_pull_secret_registry_password
  streamx_operator_chart_repository_username           = "_json_key_base64"
  streamx_operator_chart_repository_password           = var.streamx_operator_image_pull_secret_registry_password
  streamx_operator_settings = {
    "sources-auth.image.tag" : "0.1.9-jvm"
  }

  ingress_controller_apisix_settings = var.public_ip_address != null && var.public_ip_address != "" ? {
    "gateway.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group" : var.resource_group_name
    "gateway.loadBalancerIP" : var.public_ip_address
  } : {}

  tempo_create_namespace = false
  tempo_values = [
    file("${path.module}/config/monitoring/tempo/values.yaml")
  ]

  loki_create_namespace = false
  loki_values = [
    file("${path.module}/config/monitoring/loki/values.yaml")
  ]

  prometheus_stack_settings = local.grafana_host_provided ? {
    "grafana.ingress.enabled" : true
    "grafana.ingress.hosts[0]" : var.monitoring_grafana_host
    "grafana.ingress.paths[0]" : "/*"
    "grafana.ingress.tls[0].secretName" : var.monitoring_grafana_secret_name
    "grafana.ingress.tls[0].hosts[0]" : var.monitoring_grafana_host
    "grafana.ingress.annotations.cert-manager\\.io/cluster-issuer" : "letsencrypt-cert-cluster-issuer"
  } : {}
  prometheus_stack_create_namespace       = local.grafana_host_provided ? false : true
  prometheus_stack_grafana_admin_password = var.monitoring_grafana_admin_password


  minio_enabled = false
  depends_on    = [module.azure_platform, module.monitoring_loki, module.monitoring_tempo, module.grafana_secret]

}