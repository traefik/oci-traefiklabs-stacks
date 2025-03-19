terraform {
  required_version = "~> 1.5.0, < 1.12"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.30.0"
    }
  }
}

# provider "oci" {
#   tenancy_ocid = var.tenancy_ocid
#   region       = var.region
# }
