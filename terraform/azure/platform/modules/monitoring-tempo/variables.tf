variable "monitoring_storage_container_name" {
  description = "Name of the monitoring storage container"
}
variable "monitoring_storage_account_name" {
  description = "Name of the monitoring storage account"
}
variable "monitoring_storage_access_key" {
  description = "Access key of the monitoring storage account"
  sensitive   = true
}