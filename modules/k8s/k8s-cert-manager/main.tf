terraform {
  required_version = ">= 1.5.3"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.11.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = "certificate-manager"

  repository = var.cert_manager_repository 
  chart      = "cert-manager"
  version    = var.cert_manager_version
  namespace =  var.cert_manager_namespace
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}