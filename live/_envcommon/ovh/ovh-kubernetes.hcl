terraform {
  source = local.base_source_url
}

locals {
  base_source_url = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/../modules/ovh//ovh-kubernetes"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  service_name = "${get_env("OVH_PROJECT_ID")}",
  region = local.region_vars.locals.ovh_region,
  kubernetes_cluster_name = "shared-cluster",
}