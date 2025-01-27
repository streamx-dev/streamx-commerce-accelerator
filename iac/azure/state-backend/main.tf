module "tf_state_backend" {
  source  = "streamx-dev/platform/azurerm//modules/state-backend"
  version = "0.0.1"

  resource_group_name            = var.resource_group_name
  location                       = var.location
  azurerm_storage_container_name = var.azurerm_storage_container_name
  tf_backend_file_path           = "${path.module}/../platform/backend.tf"
}
