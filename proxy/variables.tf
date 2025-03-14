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

variable "chart_namespace" {
  type = string
}
