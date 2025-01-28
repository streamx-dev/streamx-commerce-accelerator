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
  default     = "streamx-commerce-accelerator-tfstate"
  description = "Azure Storage Container name."
  type        = string
}
