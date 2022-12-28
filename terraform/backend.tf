terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
      version = "0.22.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "flux" {
  # Configuration options
}

provider "kubernetes" {
  # Configuration options
}

