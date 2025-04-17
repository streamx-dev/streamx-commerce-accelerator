resource "kubernetes_namespace" "kaap" {
  metadata {
    name      = "kaap"
  }
}

resource "kubernetes_namespace" "token_secret_namespace" {
  metadata {
    name      = var.superuser_token_secret_namespace
  }
}

resource "tls_private_key" "kaap_token_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_private_key" "kaap_token_public_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "kubernetes_manifest" "kaap_token_private_key_secret" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "token-private-key"
      namespace = kubernetes_namespace.kaap.metadata[0].name
    }
    type = "Opaque"
    data = {
      "my-private.key" = replace(
        trimspace(
          replace(
            replace(
              tls_private_key.kaap_token_private_key.private_key_pem_pkcs8,
              "-----BEGIN PRIVATE KEY-----",
              ""
            ),
            "-----END PRIVATE KEY-----",
            ""
          )
        ),
        "\n",
        ""
      )
    }
  }
}

resource "kubernetes_manifest" "kaap_token_public_key_secret" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "token-public-key"
      namespace = kubernetes_namespace.kaap.metadata[0].name
    }
    type = "Opaque"
    data = {
      "my-public.key" = replace(
        trimspace(
          replace(
            replace(
              tls_private_key.kaap_token_private_key.public_key_pem,
              "-----BEGIN PUBLIC KEY-----",
              ""
            ),
            "-----END PUBLIC KEY-----",
            ""
          )
        ),
        "\n",
        ""
      )
    }
  }
}

resource "jwt_signed_token" "superuser_token" {
  algorithm = "RS256"
  key = tls_private_key.kaap_token_private_key.private_key_pem

  claims_json = jsonencode({
    sub = "superuser"})
}

resource "kubernetes_secret_v1" "superuser_token_secret" {
  metadata {
    name      = var.superuser_token_secret_name
    namespace = kubernetes_namespace.token_secret_namespace.metadata[0].name
  }

  data = {
    token = jwt_signed_token.superuser_token.token
  }

  type = "Opaque"
}
