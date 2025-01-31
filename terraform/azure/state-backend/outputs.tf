output "tf_state_backend_config" {
  description = "The Terraform state backend configuration that is set up to utilize a bucket created by this module."
  value       = module.tf_state_backend.tf_state_backend_config
}

output "arm_access_key" {
  description = "The access key created by the terraform script. To be used as `ARM_ACCESS_KEY` ENV variable for Terraform backend configuration."
  value       = module.tf_state_backend.arm_access_key
  sensitive   = true
}
