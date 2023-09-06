terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
      version = "0.33.0"
    }    
  }
}


resource "ovh_cloud_project_network_private" "this" {
  service_name = var.project_id
  vlan_id    = var.vlan_id
  name       = var.private_network_name
  regions = [var.region]
}

resource "ovh_cloud_project_network_private_subnet" "this" {
  service_name = ovh_cloud_project_network_private.this.service_name
  network_id   = ovh_cloud_project_network_private.this.id

  # whatever region, for test purpose
  region     = var.region
  start      = "10.0.0.2"
  end        = "10.0.0.254"
  network    = "10.0.0.0/24"
  dhcp       = true
  no_gateway = false

  depends_on   = [ovh_cloud_project_network_private.this]
}