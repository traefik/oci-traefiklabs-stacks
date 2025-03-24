#output "chart_output" {
#  # value = [ data.helm_template.traefik ]
#  value     = [helm_release.traefik]
#  sensitive = true
#}

#output "chart_manifest" {
#  value = yamlencode(jsondecode(helm_release.traefik.manifest))
#}

output "chart_status" {
  value = helm_release.traefik.status
}

output "chart_version" {
  value = helm_release.traefik.metadata.version
}

output "chart_notes" {
  value = data.helm_template.traefik.notes
}

output "demo_app_dashboard" {
  value = var.demo_app_create ? "https://dashboard-${module.demo-app[0].external_ip}.traefik.me" : "N/A"
}

output "demo_app_noauth" {
  value = var.demo_app_create ? "https://walkthrough-${module.demo-app[0].external_ip}.traefik.me/no-auth" : "N/A"
}

output "demo_app_basicauth" {
  value = var.demo_app_create ? "https://walkthrough-${module.demo-app[0].external_ip}.traefik.me/basic-auth" : "N/A"
}

output "demo_app_apikey" {
  value = var.demo_app_create ? "https://walkthrough-${module.demo-app[0].external_ip}.traefik.me/api-key" : "N/A"
}
