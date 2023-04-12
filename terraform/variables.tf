variable "github_owner" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
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
  default = "v2.0.0-rc.1"
}

variable "kube_config_path" {
  type    = string
  default = "~/.kube/config"
}

variable "kube_config_context" {
  type    = string
  default = null
}
