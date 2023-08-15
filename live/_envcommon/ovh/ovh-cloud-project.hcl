terraform {
  source = local.base_source_url
}

locals {
  base_source_url = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/../modules/ovh//ovh-cloud-project"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  plan_code = "project.2018"
  cloud_project_description = local.environment_vars.locals.description
}