variable "tenancy_ocid" {}
variable "region" {}
variable "oke_cluster_id" {}

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
