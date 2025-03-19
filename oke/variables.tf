variable "tenancy_ocid" {}
variable "region" {}

variable "oke_cluster_id" {
  default = ""
}

variable "oke_display_name" {
  default = "traefik-demo"
}

variable "node_shape" {
  type = string
  default = "VM.Standard.E3.Flex"
}

variable "oke_nodes_count" {
  type = string
  default = "3"
}

variable "oke_nodes_cpu" {
  type = string
  default = "1"
}

variable "oke_nodes_mem_in_gb" {
  type = string
  default = "4"
}

variable "create_simple_oke" {
  type    = bool
  default = false
}
