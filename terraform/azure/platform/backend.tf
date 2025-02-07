terraform {
  backend "azurerm" {
      resource_group_name  = "rg-adobe-summit-demo"
      storage_account_name = "tfstatetqpsj"
      container_name       = "streamx-tfstate"
      key                  = "terraform.tfstate"
  }
}
