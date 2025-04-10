# secret-init Terraform Module

The `secret-init` module is designed to manage Kubernetes Secrets in a way that allows you to initialize them with specific data (e.g., certificates, tokens) while avoiding unnecessary updates or deletions during subsequent Terraform runs.

## Purpose

The primary goal of this module is to create a Kubernetes Secret based on a provided YAML file during the initial Terraform deployment. Once the Secret is created, Terraform will **ignore the file in subsequent runs** if the Secret already exists in the Kubernetes cluster. This ensures that Terraform does not re-create or update the Secret, which is important for scenarios where the Secret might change over time (e.g., certificates expiring) and you don't want Terraform to remove or revert it.

## Features

- **Initial Secret Creation**: You provide a YAML file with the secret definition, and the module will create the Secret in Kubernetes if it doesn't already exist.
- **Prevent Changes on Subsequent Runs**: If the Secret already exists in Kubernetes, Terraform will ignore the provided YAML file, preventing unnecessary updates or deletions.
- **Useful for Expiring Secrets**: Perfect for managing sensitive data like certificates, tokens, or credentials that might change but should not be overwritten by Terraform.

## Usage

### Example Terraform Configuration

```hcl
module "secret-init" {
  source = "path/to/secret-init"

  create_namespace = true
  namespace        = your-namespace
  secret_name      = your-secret-name
  secret_file = file("path/to/your-secret.yaml")

}
