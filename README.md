# Observability cluster
Using Terraform to install the Fluxcd manifests in a Kubernetes Cluster which will, then, install everything from the Git Repository in a GitOps approach.

# Requisites
- Having a local Kubernetes Cluster running (if you're going for a remote one, then the terraform code needs to be adjusted)
- Having Terraform CLI installed

# Getting started
Since we're using Terraform to install the Flux manifests and are relaying on GitOps to do the rest, we just need to apply the Terraform code.
To be able to do that, we need to provide Fluxcd with a Token to access the Git repository it should track (i.e. for GitHub, you can create a Personal Access Token).

``` bash
cd terraform/
terraform init
terraform apply -var=<flux-token>
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.13.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | ~> 1.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | ~> 1.7.0 |

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.flux](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/resources/bootstrap_git) | resource |
<!-- END_TF_DOCS -->
