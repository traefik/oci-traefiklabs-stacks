resource "helm_release" "traefik" {
  name = "traefik"

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  namespace        = var.chart_namespace
  create_namespace = true

  # values = [file(var.chart_values)]
  values = [var.chart_values]
}

data "helm_template" "traefik" {
  name = "traefik"

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  namespace = var.chart_namespace
  values    = [var.chart_values]

  # As of v3.0.0-pre2, the data source requires this kube_version to be set.
  # Otherwise, it believes we are on k8s v1.20.
  kube_version = data.oci_containerengine_cluster.target.kubernetes_version
}

module "demo-app" {
  depends_on = [ helm_release.traefik ]
  source = "../demo-app"
  count  = var.demo_app_create ? 1 : 0

  tenancy_ocid     = var.tenancy_ocid
  region           = var.region

  oke_cluster_id = data.oci_containerengine_cluster.target.id
  oke_insecure = var.oke_insecure
  release_name = "traefik"
  target_namespace = var.chart_namespace
  providers = {
    http = http
    oci = oci
    kubernetes = kubernetes
  }
}
