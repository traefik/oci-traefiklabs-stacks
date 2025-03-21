data "kubernetes_service" "traefik" {
  metadata {
    name = var.release_name
    namespace = var.target_namespace
  }
}

locals {
  external_ip = data.kubernetes_service.traefik.status.0.load_balancer.0.ingress.0.ip
  external_ip_dashed = replace(local.external_ip, ".", "-")

  templatevars = {
    external_ip_dashed = local.external_ip_dashed,
    secret_name = kubernetes_secret.traefik_me-tls.metadata[0].name
  }
  dashboard_ingressroute = templatefile("${path.module}/ingressroutes/dashboard.tftpl", local.templatevars)
  noauth_ingressroute = templatefile("${path.module}/ingressroutes/no-auth.tftpl", local.templatevars)
  basicauth_ingressroute = templatefile("${path.module}/ingressroutes/basic-auth.tftpl", local.templatevars)
  apikey_ingressroute = templatefile("${path.module}/ingressroutes/apikey.tftpl", local.templatevars)
  weather_app_manifest = file("${path.module}/manifests/weather-app.yaml")
}

data "http" "privkey" {
  url = "https://traefik.me/privkey.pem"
  lifecycle {
    postcondition {
      condition = self.status_code == 200
      error_message = "Cannot download ${self.url} tls key"
    }
  }
}

data "http" "fullchain" {
  url = "https://traefik.me/fullchain.pem"

  lifecycle {
    postcondition {
      condition = self.status_code == 200
      error_message = "Cannot download ${self.url} tls cert"
    }
  }
}

resource "kubernetes_secret" "traefik_me-tls" {
  metadata {
    name = "traefik.me-tls"
    namespace = var.target_namespace
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.key" = data.http.privkey.response_body
    "tls.crt" = data.http.fullchain.response_body
  }
}

resource "kubernetes_manifest" "dashboard" {
  manifest = yamldecode(local.dashboard_ingressroute)
}

resource "kubernetes_manifest" "weather-app" {
  for_each = {
    for value in [
      for yaml in split(
        "\n---\n",
        "\n${replace(local.weather_app_manifest, "/(?m)^---[[:blank:]]*(#.*)?$/", "---")}\n"
      ) :
      yamldecode(yaml)
      if trimspace(replace(yaml, "/(?m)(^[[:blank:]]*(#.*)?$)+/", "")) != ""
    ] : "${value["metadata"]["name"]}-${value["kind"]}" => value
  }
  manifest = each.value
}

resource "kubernetes_manifest" "no-auth" {
  depends_on = [ kubernetes_manifest.weather-app ]

  manifest = yamldecode(local.noauth_ingressroute)
}

resource "kubernetes_manifest" "basic-auth" {
  depends_on = [ kubernetes_manifest.weather-app ]

  for_each = {
    for value in [
      for yaml in split(
        "\n---\n",
        "\n${replace(local.basicauth_ingressroute, "/(?m)^---[[:blank:]]*(#.*)?$/", "---")}\n"
      ) :
      yamldecode(yaml)
      if trimspace(replace(yaml, "/(?m)(^[[:blank:]]*(#.*)?$)+/", "")) != ""
    ] : "${value["metadata"]["name"]}-${value["kind"]}" => value
  }
  manifest = each.value
}

resource "kubernetes_manifest" "api-key" {
  depends_on = [ kubernetes_manifest.weather-app ]

  # Create a map { "kind--name" => yaml_doc } from the multi-document yaml text.
  # Each element is a separate kubernetes resource.
  # Must use \n---\n to avoid splitting on strings and comments containing "---".
  # YAML allows "---" to be the first and last line of a file, so make sure
  # raw yaml begins and ends with a newline.
  # The "---" can be followed by spaces, so need to remove those too.
  # Skip blocks that are empty or comments-only in case yaml began with a comment before "---".
  for_each = {
    for value in [
      for yaml in split(
        "\n---\n",
        "\n${replace(local.apikey_ingressroute, "/(?m)^---[[:blank:]]*(#.*)?$/", "---")}\n"
      ) :
      yamldecode(yaml)
      if trimspace(replace(yaml, "/(?m)(^[[:blank:]]*(#.*)?$)+/", "")) != ""
    ] : "${value["metadata"]["name"]}-${value["kind"]}" => value
  }
  manifest = each.value
}
