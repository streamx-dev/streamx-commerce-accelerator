locals {
  use_file            = length(data.local_sensitive_file.cert_file) > 0
  default_secret_yaml = <<EOT
apiVersion: v1
kind: Secret
metadata:
  name: "${var.secret_name}"
  namespace: "${var.secret_namespace}"
EOT
}

data "local_sensitive_file" "cert_file" {
  filename = var.cert_file
  count    = fileexists(var.cert_file) ? 1 : 0
}

resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.secret_namespace
  }
}

resource "kubectl_manifest" "cert_secret" {
  yaml_body          = local.use_file ? one(data.local_sensitive_file.cert_file[*].content) : local.default_secret_yaml
  override_namespace = var.secret_namespace

  lifecycle {
    #The spite the warning which says it has no effect - IT HAS !
    ignore_changes = [
      yaml_body,
      yaml_incluster
    ]
  }
}