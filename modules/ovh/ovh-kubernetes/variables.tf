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

variable "flavor_name" {
  description = "The name of the flavor to use"
  type        = string
  default     = "d2-4"
}

variable "desired_nodes" {
  description = "The desired number of nodes"
  type        = number
  default     = 1
}

variable "min_nodes" {
  description = "The minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "The maximum number of nodes"
  type        = number
  default     = 1
}