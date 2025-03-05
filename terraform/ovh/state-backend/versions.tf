terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 1.4.0"
    }
  }
}