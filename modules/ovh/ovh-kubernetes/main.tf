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