terraform {
  backend "azurerm" {
    resource_group_name  = "streamx-commerce-accelerator"
    storage_account_name = "tfstatebujel"
    container_name       = "streamx-commerce-accelerator-tfstate"
    key                  = "terraform.tfstate"
  }
}
