variable "monitoring_grafana_host" {
  description = "Grafana host name. This settings creates ingress for grafana exposed on provided host. If null or empty ingress for grafana is not be created"
  default     = null
  type        = string
}

variable "monitoring_grafana_secret_name" {
  description = "Name of the secret for Grafana TLS certificate"
  default     = "grafana.crt"
  type        = string
}

variable "monitoring_grafana_cert_file" {
  description = "Path to the file with grafana certificate"
  default     = null
  type        = string
}

variable "monitoring_grafana_secret_namespace" {
  description = "Namespace for grafana secret"
  default     = "prometheus-stack"
  type        = string
}