resource "kubernetes_namespace" "tempo" {
  metadata {
    name = "tempo"
  }
}


resource "kubernetes_secret_v1" "tempo_azure_access_keys" {

  metadata {
    name      = "azure-access-keys"
    namespace = kubernetes_namespace.tempo.metadata[0].name
  }

  data = {
    CONTAINER_NAME     = var.monitoring_storage_container_name
    ACCOUNT_NAME       = var.monitoring_storage_account_name
    ACCOUNT_ACCESS_KEY = var.monitoring_storage_access_key

  }
}