output "superuser_token" {
  description = "Pulsar superuser token"
  value =  jwt_signed_token.superuser_token.token
  sensitive = true
}

output "pulsar_token_secret_name" {
  description = "Token secret name"
  value = kubernetes_secret_v1.superuser_token_secret.metadata[0].name
}

output "pulsar_token_secret_key" {
  description = "Token secret key"
  value = "token"
}