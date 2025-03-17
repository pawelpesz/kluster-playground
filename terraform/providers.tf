terraform {
  required_version = "~> 1.11.0"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.2"
    }
  }
}

provider "flux" {
  kubernetes = {
    config_path    = var.kube_config_path
    config_context = var.kube_config_context
  }
  git = {
    url = "https://github.com/${var.github_owner}/${var.repository_name}.git"
    http = {
      username = var.github_owner
      password = var.github_token
    }
  }
}
