output "external_ip" {
  value = local.external_ip_dashed
}

output "dashboard" {
  value = local.dashboard_ingressroute
}

output "metadata" {
  value = kubernetes_secret.traefik_me-tls.metadata
}
