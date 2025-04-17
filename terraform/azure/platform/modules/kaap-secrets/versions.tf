terraform {
  required_version = ">= 1.0.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }
    jwt = {
      source  = "camptocamp/jwt"
      version = "~> 1.1.2"
    }
  }
}


