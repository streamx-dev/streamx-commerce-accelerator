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

variable "cluster_name" {
  default     = "streamx-commerce-accelerator"
  description = "Kubernetes cluster name."
  type        = string
}

variable "cert_manager_lets_encrypt_issuer_acme_email" {
  description = "Email passed to acme server."
  type        = string
}

variable "cert_manager_lets_encrypt_issuer_prod_letsencrypt_server" {
  description = "Determines if created Cluster Issuer should use prod or staging acme server."
  type        = bool
  default     = false
}

variable "streamx_operator_image_pull_secret_registry_email" {
  description = "StreamX Operator container image registry user email."
  type        = string
}

variable "streamx_operator_image_pull_secret_registry_password" {
  description = "StreamX Operator container image registry user password."
  type        = string
  sensitive   = true
}

variable "public_ip_id" {
  default     = null
  description = "Public IP id for kubernetes cluster"
  type        = string
}

variable "public_ip_address" {
  default     = null
  description = "Public IP address"
  type        = string
}

variable "user_identity_id" {
  default     = null
  description = "The id of the user used by Terraform to create cluster"
  type        = string
}