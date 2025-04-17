variable "superuser_token_secret_namespace" {
  description = "Secret namespace"
  default = "streamx-operator"
  type = string
}

variable "superuser_token_secret_name" {
  description = "Secret names"
  default = "sx-operator-pulsar-superuser"
  type = string
}