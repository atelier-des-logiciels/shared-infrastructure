locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  region = local.region_vars.locals.region
  
  elements        = split("/", get_path_from_repo_root())
  namespace    = "${local.elements[length(local.elements)-1]}" 
  moduleFolder    = path_relative_to_include()

  environment_with_dashes = replace(local.env_vars.locals.environment, ".", "-")
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket = "tf-remote-state-${local.environment_with_dashes}"
    key    = "${local.moduleFolder}/terraform.tfstate"
    region = "${local.region}"
    endpoint = "${local.env_vars.locals.backend_address}"
    skip_credentials_validation = true
    skip_region_validation = true
  }
}
EOF
}