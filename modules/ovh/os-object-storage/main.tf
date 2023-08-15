terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.52.1"
    }
  }
}

provider "openstack" {
  domain_name = "default"
}

resource "openstack_objectstorage_container_v1" "this" {
  name   = var.container_name
}