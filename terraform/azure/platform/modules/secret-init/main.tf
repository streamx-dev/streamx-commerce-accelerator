locals {
  use_file            = length(data.local_sensitive_file.secret_file) > 0
  default_secret_yaml = <<EOT
apiVersion: v1
kind: Secret
metadata:
  name: "${var.secret_name}"
  namespace: "${var.namespace}"
EOT
}

data "local_sensitive_file" "secret_file" {
  filename = var.secret_file
  count    = fileexists(var.secret_file) ? 1 : 0
}

resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "kubectl_manifest" "secret" {
  yaml_body          = local.use_file ? one(data.local_sensitive_file.secret_file[*].content) : local.default_secret_yaml
  override_namespace = var.namespace

  lifecycle {
    #The spite the warning which says it has no effect - IT HAS !
    ignore_changes = [
      yaml_body,
      yaml_incluster
    ]
  }
}