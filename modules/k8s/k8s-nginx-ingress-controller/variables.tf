variable "ingress_nginx_namespace" {
  description = "Namespace for the ingress controller"
  default     = "kube-system"
}

variable "ingress_nginx_chart_repository" {
  description = "Ingress Nginx repository"
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
}

variable "ingress_nginx_chart_version" {
  description = "Ingress Nginx version"
  type        = string
  default     = "4.7.0"
}