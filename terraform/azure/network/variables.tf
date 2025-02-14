variable "name" {
  default     = "streamx-commerce-accelerator-public-ip"
  description = "The name of public ip resource"
  type        = string
}

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

variable "dns_label" {
  default     = "streamx"
  description = "Label for the Domain Name"
  type        = string
}
