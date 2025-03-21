output "kubernetes_version" {
  value = data.oci_containerengine_cluster.target.kubernetes_version
}

output "external_ip" {
  value = local.external_ip_dashed
}

output "dashboard" {
  value = local.dashboard_ingressroute
}

output "metadata" {
  value = kubernetes_secret.traefik_me-tls.metadata
}
