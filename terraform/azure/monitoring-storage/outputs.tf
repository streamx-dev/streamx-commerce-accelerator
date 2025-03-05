output "access_key" {
  description = "The access key created by the terraform script."
  value       = module.monitoring_storage.access_key
  sensitive   = true
}

output "account_name" {
  description = "The name of account created by the terraform script."
  value       = module.monitoring_storage.account_name
}

output "container_name" {
  description = "The name of container created by the terraform script."
  value       = module.monitoring_storage.container_name
}
