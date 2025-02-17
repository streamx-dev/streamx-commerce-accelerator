resource "azurerm_public_ip" "aks_ip" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  domain_name_label   = var.dns_label
  allocation_method   = "Static"
}