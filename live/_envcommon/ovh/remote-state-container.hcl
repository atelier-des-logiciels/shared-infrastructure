terraform {
  source = local.base_source_url
}

locals {
  base_source_url = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/../modules/ovh//os-object-storage"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  container_name = "tf-remote-state"
}