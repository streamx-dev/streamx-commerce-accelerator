variable "resource_group_name" {
  default     = "rg-adobe-summit-demo"
  description = "Azure resources group name."
  type        = string
}

variable "location" {
  default     = "East US"
  description = "Azure location."
  type        = string
}

variable "cluster_name" {
  default     = "streamx-example"
  description = "Kubernetes cluster name."
  type        = string
}

variable "cert_manager_lets_encrypt_issuer_acme_email" {
  description = "Email passed to acme server."
  type        = string
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
  description = "Public IP id for kubernetes cluster"
  type        = string
}

variable "public_ip_address" {
  description = "Public IP address"
  type        = string
}

variable "user_identity_id" {
  description = "The id of the user used by Terraform to create cluster"
  type        = string
}