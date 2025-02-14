output "public_ip_id" {
  value = azurerm_public_ip.aks_ip.id
}

output "public_ip_address" {
  value = azurerm_public_ip.aks_ip.ip_address
}

output "domain_name" {
  value = azurerm_public_ip.aks_ip.fqdn
}