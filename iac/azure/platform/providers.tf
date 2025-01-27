

provider "kubernetes" {
  host                   = module.azure_platform.kubeconfig.host
  client_certificate     = base64decode(module.azure_platform.kubeconfig.client_certificate)
  client_key             = base64decode(module.azure_platform.kubeconfig.client_key)
  cluster_ca_certificate = base64decode(module.azure_platform.kubeconfig.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.azure_platform.kubeconfig.host
    client_certificate     = base64decode(module.azure_platform.kubeconfig.client_certificate)
    client_key             = base64decode(module.azure_platform.kubeconfig.client_key)
    cluster_ca_certificate = base64decode(module.azure_platform.kubeconfig.cluster_ca_certificate)
  }
}

provider "kubectl" {
  load_config_file       = false
  host                   = module.azure_platform.kubeconfig.host
  client_certificate     = base64decode(module.azure_platform.kubeconfig.client_certificate)
  client_key             = base64decode(module.azure_platform.kubeconfig.client_key)
  cluster_ca_certificate = base64decode(module.azure_platform.kubeconfig.cluster_ca_certificate)
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}
