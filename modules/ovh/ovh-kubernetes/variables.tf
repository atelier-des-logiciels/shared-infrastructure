variable "service_name" {
  description = "The id of the public cloud project"
  type        = string
}

variable "region" {
  description = "The region to use"
  type        = string 
}

variable "private_network_id" {
  description = "The id of the private network"
  type        = string
}

variable "kubernetes_cluster_name" {
  description = "The name of the kubernetes cluster"
  type        = string
  default     = "kubernetes_cluster"
}