terraform {
  required_version = "~> 1.4"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "~> 0.25"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
}

provider "flux" { }

provider "kubectl" {
  config_path    = var.kube_config_path
  config_context = var.kube_config_context
}

provider "kubernetes" {
  config_path    = var.kube_config_path
  config_context = var.kube_config_context
}
