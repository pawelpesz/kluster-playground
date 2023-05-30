# All-in-one install
resource "flux_bootstrap_git" "flux" {
  version                = var.flux_version
  path                   = var.target_sync_path
  components_extra       = var.flux_components_extra
  network_policy         = false
  kustomization_override = file("${path.module}/kustomization.yaml")
}
