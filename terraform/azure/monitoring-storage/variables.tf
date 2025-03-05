variable "resource_group_name" {
  default     = "streamx-commerce-accelerator"
  description = "Azure resources group name."
  type        = string
}

variable "location" {
  default     = "West Europe"
  description = "Azure location."
  type        = string
}

variable "azurerm_storage_container_name" {
  default     = "streamx-commerce-accelerator-monitoring"
  description = "Azure Storage Container name."
  type        = string
}

variable "storage_account_name_prefix" {
  default     = "streamxmonitoring"
  description = "Azure Storage Account name prefix."
  type        = string
}