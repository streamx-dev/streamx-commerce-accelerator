terraform {
  backend "azurerm" {
      resource_group_name  = "rg-adobe-summit-demo"
      storage_account_name = "tfstatep8uvb"
      container_name       = "streamx-storagecontainer"
      key                  = "platform.tfstate"
  }
}
