variable "service_name" {
  description = "The id of the public OVH cloud project"
  type        = string
}

variable "cluster_name" {
  default     = "streamx"
  description = "The name of the kubernetes cluster."
  type        = string
}

variable "region" {
  default     = "waw1"
  description = "Region of cloud deployment"
  type        = string
}

variable "network_id" {
  description = "Network id to attach cluster"
  type        = string
}

variable "nodes_subnet_id" {
  description = "Nodes subnet ID"
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

variable "public_ip_address" {
  default = null
  description = "Public IP address"
  type        = string
}
