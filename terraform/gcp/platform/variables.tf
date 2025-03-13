variable gcp_project_id {
  description = "ID of project on GCP where the cluster is created"
  type        = string
}

variable "gcp_cluster_name" {
  default     = "streamx"
  description = "The name of the kubernetes cluster."
  type        = string
}

variable "gcp_cluster_location" {
  default     = "europe-central2-a"
  description = "A valid GCP location (region or zone) in which the kubernetes cluster will be available."
  type        = string
}

variable "vpc_network_link" {
  default = null
  type    = string
}

variable "subnet_link" {
  default = null
  type    = string
}

variable "cert_manager_lets_encrypt_issuer_acme_email" {
  description = "Email passed to acme server."
  type        = string
}

variable "streamx_operator_image_pull_secret_registry_email" {
  default     = "sx-dist-tests-gh-gar-read@streamx-releases.iam.gserviceaccount.com"
  description = "StreamX Operator container image registry user email."
  type        = string
}

variable "streamx_operator_image_pull_secret_registry_password" {
  description = "StreamX Operator container image registry user password."
  type        = string
}

variable "public_ip_address" {
  default     = null
  description = "Allocated before IP to setup StreamX on."
  type        = string
}
