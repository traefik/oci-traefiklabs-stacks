variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "oke_cluster_id" {
  type = string
}

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
