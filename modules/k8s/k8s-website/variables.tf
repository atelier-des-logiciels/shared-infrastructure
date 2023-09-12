variable "namespace" {
  description = "The namespace to deploy the website to"
  type        = string
  default     = "website"
}

variable "ingress_hostname" {
  description = "The hostname to use for the ingress"
  type        = string
  default     = "example.com"
}

variable "issuer_type" {
  description = "Type of issuer to create"
  type        = string
  default = "staging"
  validation {
    condition     = contains(["staging", "production"], var.issuer_type)
    error_message = "Allowed values for issuer_type are \"staging\", \"production\""
  }
}

variable "acme_registration_email" {
  description = "Email address used for ACME registration"
  type        = string
}

variable "ingress_class" {
  description = "Ingress class to use for HTTP01 challenge"
  type        = string
  default = "nginx"
}

variable "ingress_annotations" {
  description = "annotations to use for ingress"
  type = map(string)
  default = {}
}
