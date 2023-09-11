terraform {
  source = local.base_source_url
}

locals {
  base_source_url = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/../modules/k8s//k8s-cert-manager"
}

inputs = {
}