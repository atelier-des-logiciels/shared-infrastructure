terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
      version = "0.33.0"
    }    
  }
}

resource "ovh_cloud_project_kube" "this" {
  service_name  = var.service_name
  name          = var.kubernetes_cluster_name
  region        = var.region

  private_network_id = var.private_network_id 

  private_network_configuration {
      default_vrack_gateway              = ""
      private_network_routing_as_default = false
  }
}

resource "ovh_cloud_project_kube_nodepool" "this" {
  service_name  = var.service_name
  kube_id       = ovh_cloud_project_kube.this.id
  name          = "default" 
  flavor_name   = var.flavor_name
  desired_nodes = var.desired_nodes
  min_nodes     = var.min_nodes
  max_nodes     = var.max_nodes
}