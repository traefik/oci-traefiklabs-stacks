resource "helm_release" "traefik" {
  name = "traefik"

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  namespace        = var.chart_namespace
  create_namespace = true

  values = [file(var.chart_values)]
}

data "helm_template" "traefik" {
  name = "traefik"

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  namespace = var.chart_namespace
  # As of v3.0.0-pre2, the data source requires this kube_version to be set.
  # Otherwise, it believes we are on k8s v1.20.
  kube_version = data.oci_containerengine_cluster.target.kubernetes_version
}
