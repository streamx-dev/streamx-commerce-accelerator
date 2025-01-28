module "resource_group" {
  source  = "streamx-dev/platform/azurerm//modules/resource-group"
  version = "0.0.1"

  resources_group_name = var.resource_group_name
  location             = var.location
}
