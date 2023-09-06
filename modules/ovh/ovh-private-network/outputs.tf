output "private_network_id" {
  description = "The Openstack ID of the private network"
  value = one(ovh_cloud_project_network_private.this.regions_attributes[*].openstackid)
}