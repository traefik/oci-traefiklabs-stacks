variable "tenancy_ocid" {}
variable "region" {}

variable "oke_cluster_id" {
  type    = string
  default = ""
}
variable "oke_cluster_name" {
  type    = string
  default = "traefik-demo"
}
variable "oke_cluster_create" {
  type    = bool
  default = false
}
variable "oke_insecure" {
  type    = bool
  default = false
}

variable "chart_values" {
  type = string
}
variable "chart_hub_token" {
  type      = string
  sensitive = true
}

variable "chart_hub_version" {
  type = string
}

variable "chart_namespace" {
  type = string
}

variable "chart_create_namespace" {
  type = bool
  default = false
}
