terraform {
  backend "azurerm" {
      resource_group_name  = "demo-puresight-starter"
      storage_account_name = "tfstate41efi"
      container_name       = "demo-puresight-starter-tfstate"
      key                  = "terraform.tfstate"
  }
}
