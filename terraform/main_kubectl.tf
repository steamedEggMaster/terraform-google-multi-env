module "kubectl_manifest" {
  source = "../../../../../modules/kubernetes/kubectl_manifest"

  for_each = local.yaml.yaml_data.kubectl

  yaml_body = file("${local.file_path}/${each.value.yaml_body}")

  depends_on = [helm_release.this]
}