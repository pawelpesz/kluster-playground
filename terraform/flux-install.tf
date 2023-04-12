# All-in-one install
resource "flux_bootstrap_git" "flux" {
  version        = var.flux_version
  path           = var.target_sync_path
  network_policy = false
}
