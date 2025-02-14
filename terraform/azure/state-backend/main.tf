module "tf_state_backend" {
  source = "/Users/marekczajkowski/workspace/terraform-azurerm-platform/modules/state-backend"
  #version = "0.0.1"

  resource_group_name            = var.resource_group_name
  location                       = var.location
  azurerm_storage_container_name = var.azurerm_storage_container_name
  tf_backends                    = {
    "platform.tfstate" : "${path.module}/../platform/backend.tf"
    "network.tfstate" : "${path.module}/../network/backend.tf"
  }
}
