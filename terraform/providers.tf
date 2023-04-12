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

provider "flux" {
  # config_path from KUBE_CONFIG_PATH
}

provider "kubernetes" {
  # config_path from KUBE_CONFIG_PATH
  # config_context from KUBE_CTX
}
