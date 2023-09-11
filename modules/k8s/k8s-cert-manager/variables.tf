variable "cert_manager_repository" {
  description = "Cert Manager repository"
  type        = string
  default     = "https://charts.jetstack.io"
}

variable "cert_manager_version" {
  description = "Version of cert-manager to install"
  type        = string
  default     = "1.11.0"
}

variable "cert_manager_namespace" {
  description = "Namespace for cert-manager"
  type        = string
  default     = "cert-manager"
}