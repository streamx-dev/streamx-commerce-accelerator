variable "resource_group_name" {
  default     = "streamx-example"
  description = "Azure resources group name."
  type        = string
}

variable "location" {
  default     = "East US"
  description = "Azure location."
  type        = string
}

variable "azurerm_storage_container_name" {
  default     = "streamx-example-tfstate"
  description = "Azure Storage Container name."
  type        = string
}
