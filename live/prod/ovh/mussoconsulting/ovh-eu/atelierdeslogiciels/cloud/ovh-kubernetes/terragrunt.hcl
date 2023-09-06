include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

dependency "ovh_private_network" {
  config_path = "../ovh-private-network"
}

inputs = {
  private_network_id = dependency.ovh_private_network.outputs.private_network_id
}

include "ovh_kubernetes" {
  path = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/_envcommon/ovh/ovh-kubernetes.hcl"
}