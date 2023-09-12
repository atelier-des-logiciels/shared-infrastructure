terraform {
  required_version = ">= 1.5.3"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

locals {
  website_hostname = "${var.namespace}.${var.ingress_hostname}"
}



locals {
  issuer_server = var.issuer_type == "staging" ? "https://acme-staging-v02.api.letsencrypt.org/directory" : "https://acme-v02.api.letsencrypt.org/directory"
}

resource "kubernetes_manifest" "issuer" {
  manifest = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: letsencrypt
      namespace: ${kubernetes_namespace.namespace.metadata[0].name}
    spec:
      acme:
        # The ACME server URL
        server: ${local.issuer_server}
        # Email address used for ACME registration
        email: ${var.acme_registration_email}
        # Name of a secret used to store the ACME account private key
        privateKeySecretRef:
          name: letsencrypt-prod
        # Enable the HTTP-01 challenge provider
        solvers:
        - http01:
            ingress:
              class:  ${var.ingress_class}
    EOF                  
  )
}

resource "kubernetes_manifest" "certificate" {
  depends_on = [ kubernetes_manifest.issuer ]
  manifest = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: ${local.website_hostname}
      namespace: ${kubernetes_namespace.namespace.metadata[0].name}
    spec:
      secretName: cert-${local.website_hostname}
      issuerRef:
        name: letsencrypt
      commonName: ${local.website_hostname}
      dnsNames:
      - ${local.website_hostname}
    EOF
  )
}

resource "template_file" "config_nginx" {
  template = file("${path.module}/default.conf.tpl")
  vars = {
    hostname = "${var.namespace}.${var.ingress_hostname}"
  }
}

resource "local_file" "nginx_config" {
  content  = template_file.config_nginx.rendered
  filename = "${path.root}/nginx-config-${sha1(template_file.config_nginx.rendered)}.conf"
}

resource "kubernetes_config_map" "config_nginx" {
  metadata {
    name = "website-nginx-config"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  data = {
    "default.conf" = local_file.nginx_config.content
  }
}

resource "kubernetes_deployment_v1" "website" {
  metadata {
    name = "website"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "website"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "website"
      }
    }
    template {
      metadata {
        labels = {
          app = "website"
        }
      }
      spec {
        container {
          image = "nginx" 
          name = "website"
          image_pull_policy = "Always"
          port {
            container_port = 8443
          }
          volume_mount {
            name = kubernetes_config_map.config_nginx.metadata[0].name
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path = "default.conf"
          }

          volume_mount {
            name = "cert-website"
            mount_path = "/etc/nginx/tls"
            read_only = true
          }
        }

        volume {
          name = kubernetes_config_map.config_nginx.metadata[0].name
          config_map {
            name = kubernetes_config_map.config_nginx.metadata[0].name
          }
        }

        volume {
          name = "cert-website"
          secret {
            secret_name = "cert-${local.website_hostname}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "website" {
  depends_on = [
    kubernetes_deployment_v1.website
  ]
  metadata {
    namespace = kubernetes_namespace.namespace.metadata[0].name 
    name = "website"
  }
  spec {
    selector = {
      app = "website" 
    }
    port {
      port        = 8443
      target_port = 8443
    }

    type = "ClusterIP" 
  }
}

resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name = "website"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    annotations = var.ingress_annotations
  }

  spec {
    rule {
      host = local.website_hostname
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.website.metadata[0].name
              port {
                number = kubernetes_service.website.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}