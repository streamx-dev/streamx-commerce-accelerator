module "tf_state_backend" {
  source  = "streamx-dev/platform/azurerm//modules/state-backend"
  version = "0.0.2"

  resource_group_name            = var.resource_group_name
  location                       = var.location
  azurerm_storage_container_name = var.azurerm_storage_container_name
  tf_backends                    = {
    "platform.tfstate" : "${path.module}/../platform/backend.tf"
    "network.tfstate" : "${path.module}/../network/backend.tf"
  }
}
