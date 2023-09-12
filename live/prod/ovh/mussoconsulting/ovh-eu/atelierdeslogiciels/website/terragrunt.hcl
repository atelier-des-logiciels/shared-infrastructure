include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

include "k8s-website" {
  path = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/_envcommon/k8s/k8s-website.hcl"
}