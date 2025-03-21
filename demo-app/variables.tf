variable "tenancy_ocid" {}
variable "region" {}

variable "oke_cluster_id" {}
variable "oke_insecure" {
  type    = bool
  default = false
}

variable "release_name" {
   type = string
  default = "traefik"
}

variable "target_namespace" {
  type = string
  default = "traefik"
}

