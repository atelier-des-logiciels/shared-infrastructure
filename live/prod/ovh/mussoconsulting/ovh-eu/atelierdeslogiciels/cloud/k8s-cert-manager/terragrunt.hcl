include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

dependency "ovh-kubernetes" {
  config_path = "../ovh-kubernetes"
}

include "k8s-cert-manager" {
  path = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/_envcommon/k8s/k8s-cert-manager.hcl"
}