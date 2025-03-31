locals {
  use_file            = length(data.local_sensitive_file.grafana_cert_file) > 0
  grafana_secret_yaml = <<EOT
apiVersion: v1
kind: Secret
metadata:
  name: "${var.monitoring_grafana_secret_name}"
  namespace: "prometheus-stack"
EOT
}

resource "kubernetes_namespace" "prometheus_stack" {
  metadata {
    name = "prometheus-stack"
  }
}

data "local_sensitive_file" "grafana_cert_file" {
  filename = var.monitoring_grafana_cert_file
  count    = fileexists(var.monitoring_grafana_cert_file) ? 1 : 0
}

resource "kubectl_manifest" "grafana_secret" {
  yaml_body          = local.use_file ? one(data.local_sensitive_file.grafana_cert_file[*].content) : local.grafana_secret_yaml
  override_namespace = kubernetes_namespace.prometheus_stack.metadata[0].name

  lifecycle {
    #The spite the warning which says it has no effect - IT HAS !
    ignore_changes = [
      yaml_body,
      yaml_incluster
    ]
  }
}