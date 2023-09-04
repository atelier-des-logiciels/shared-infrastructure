include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

include "ovh_cloud_project" {
  path = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/_envcommon/ovh/ovh-private-network.hcl"
}