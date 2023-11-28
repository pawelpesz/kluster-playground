variable "github_owner" {
  type = string
}

variable "github_token" {
  description = "Fine-grained token with read access to metadata and *read/write* access to code"
  type        = string
  sensitive   = true
}

variable "repository_name" {
  type = string
}

variable "target_sync_path" {
  type    = string
  default = "clusters/staging"
}

variable "flux_version" {
  type    = string
  default = "v2.1.2"
}

variable "flux_components_extra" {
  type = set(string)
  default = [
    "image-reflector-controller",
    "image-automation-controller"
  ]
}

variable "kube_config_path" {
  type    = string
  default = "~/.kube/config"
}

variable "kube_config_context" {
  type    = string
  default = null
}
