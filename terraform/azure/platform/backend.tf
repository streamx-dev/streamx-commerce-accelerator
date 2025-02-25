terraform {
  backend "azurerm" {
    resource_group_name  = "demo-puresight-starter"
    storage_account_name = "tfstateyfyg6"
    container_name       = "streamx-commerce-accelerator-tfstate"
    key                  = "platform.tfstate"
  }
}
