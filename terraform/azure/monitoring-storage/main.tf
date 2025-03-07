module "monitoring_storage" {
  source  = "streamx-dev/platform/azurerm//modules/storage-container"
  version = "0.0.4"

  resource_group_name            = var.resource_group_name
  location                       = var.location
  azurerm_storage_container_name = var.azurerm_storage_container_name
  storage_account_name_prefix    = var.storage_account_name_prefix
  storage_account_tier           = "Premium"
  storage_account_kind           = "BlockBlobStorage"
}
