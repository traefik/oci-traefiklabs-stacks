terraform {
  required_version = "~> 1.5.0, < 1.12"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.30.0"
    }
    helm = {
      version = "3.0.0-pre2"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}

module "oke" {
  source = "../oke"
  count  = var.oke_cluster_create ? 1 : 0

  tenancy_ocid     = var.tenancy_ocid
  region           = var.region
  oke_display_name = var.oke_cluster_name
  providers = {
    oci = oci
  }
}

data "oci_containerengine_cluster" "target" {
  cluster_id = var.oke_cluster_create ? module.oke[0].cluster_id : var.oke_cluster_id
}

data "oci_containerengine_cluster_kube_config" "target" {
  cluster_id = data.oci_containerengine_cluster.target.id
}

locals {
  kube_config_content    = data.oci_containerengine_cluster_kube_config.target.content
  cluster_endpoint       = yamldecode(local.kube_config_content)["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(yamldecode(local.kube_config_content)["clusters"][0]["cluster"]["certificate-authority-data"])
}

provider "helm" {
  kubernetes = {
    host                   = local.cluster_endpoint
    cluster_ca_certificate = local.cluster_ca_certificate
    insecure               = var.oke_insecure
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "docker"
      # args        = ["run", "--rm", "-t", "-v", "/home/michel/.oci:/oracle/.oci", "ghcr.io/oracle/oci-cli", "ce", "cluster", "generate-token", "--cluster-id", data.oci_containerengine_cluster.target.id, "--region", var.region]
      args = ["run", "--rm", "-t", "-u", "1101:1101", "-v", "/home/orm:/home/orm", "-e", "OCI_CLI_AUTH", "-e", "OCI_CLI_CONFIG_FILE", "-e", "OCI_CLI_CLOUD_SHELL", "-e", "OCI_CLI_USE_INSTANCE_METADATA_SERVICE", "ghcr.io/oracle/oci-cli", "ce", "cluster", "generate-token", "--cluster-id", data.oci_containerengine_cluster.target.id, "--region", var.region]
    }
  }
}
