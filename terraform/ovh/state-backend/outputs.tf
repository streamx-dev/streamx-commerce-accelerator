output "access_key" {
  description = "The access key created by the terraform script. To be used as `AWS_ACCESS_KEY_ID` ENV variable for Terraform S3 backend configuration."
  value       = module.tf_state_backend.access_key
}

output "secret_key" {
  description = "The secret key created by the terraform script.  To be used as `AWS_SECRET_ACCESS_KEY` ENV variable for Terraform S3 backend configuration."
  value       = module.tf_state_backend.secret_key
  sensitive   = true
}

output "tf_state_backend_config" {
  description = "The Terraform state backend configuration that is set up to utilize a bucket created by this module."
  value = module.tf_state_backend.tf_state_backend_config
}