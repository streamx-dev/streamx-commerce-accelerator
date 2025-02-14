output "public_ip_id" {
  value = azurerm_public_ip.aks_ip.id
  description = "Id of the IP resources in azure"
}

output "public_ip_address" {
  value = azurerm_public_ip.aks_ip.ip_address
  description = "Static public IP address"
}

output "domain_name" {
  value = azurerm_public_ip.aks_ip.fqdn
  description = "Fully qualified domain name of azure kubernetes host"
}