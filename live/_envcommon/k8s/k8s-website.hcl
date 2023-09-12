terraform {
  source = local.base_source_url
}

locals {
  base_source_url = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/../modules/k8s//k8s-website"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  namespace               = "example"
  ingress_hostname        = local.environment_vars.locals.ingress_hostname
  issuer_type             = "production"
  acme_registration_email = local.environment_vars.locals.acme_registration_email
  ingress_annotations = {
    "kubernetes.io/ingress.class": "nginx",
    "nginx.ingress.kubernetes.io/force-ssl-redirect" : "true",
    "nginx.ingress.kubernetes.io/ssl-redirect" : "true",
    "nginx.ingress.kubernetes.io/ssl-passthrough" : "true",
  }
}
