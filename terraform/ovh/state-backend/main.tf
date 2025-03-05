module "tf_state_backend" {
  source ="/Users/andrzej/repo/terraform-ovh-platform/modules/state-backend"
  ovh_public_cloud_project_id            = var.service_name
  region = var.region
  bucket_name=var.bucket_name
  s3_endpoint=var.s3_endpoint
  tf_backends = {
    "platform.tfstate" : "${path.module}/../platform/backend.tf"
    "network.tfstate" : "${path.module}/../network/backend.tf"
  }
}
