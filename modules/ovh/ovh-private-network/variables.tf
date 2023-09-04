variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region to use"
  type        = string 
  default     = "GRA11"
}

variable "private_network_name" {
  description = "The name of the private network"
  type        = string
  default     = "terraform_private_net"
}

variable "vlan_id" {
  description = "The VLAN ID"
  type        = number
  default     = 0
}