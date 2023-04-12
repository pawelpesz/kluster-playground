variable "github_owner" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "flux_token" {
  type      = string
  sensitive = true
}

variable "target_sync_path" {
  type    = string
  default = "clusters/staging"
}
