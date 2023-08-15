# include "backend" {
#   path = "${find_in_parent_folders("backend.hcl")}"
# }

include "object-storage" {
  path = "${dirname(find_in_parent_folders("terragrunt-root.hcl"))}/_envcommon/ovh/remote-state-container.hcl"
}