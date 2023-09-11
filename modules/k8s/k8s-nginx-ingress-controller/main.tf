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

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = var.ingress_nginx_namespace
  create_namespace = true
  repository = var.ingress_nginx_chart_repository 
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_chart_version 

  set {
    name  = "controller.kind"
    value = "DaemonSet"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name = "controller.extraArgs.enable-ssl-passthrough"
    value = "true"
  }
}