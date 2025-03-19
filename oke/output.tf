output "latest_k8s_version" {
  value = local.kubernetes_version
}

data "oci_core_image" "oke" {
    image_id = local.image_id
}

output "image_name" {
  value = data.oci_core_image.oke.display_name
}

output "image_id" {
  value = local.image_id
}
