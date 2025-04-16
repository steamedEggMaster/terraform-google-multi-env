resource "helm_release" "this" {
  for_each = local.yaml.yaml_data.helm

  name = each.value.name

  repository    = try(each.value.repository, "")
  chart         = each.value.chart
  namespace     = each.value.namespace
  version       = try(each.value.version, "")
  max_history   = try(each.value.max_history, 10)
  force_update  = try(each.value.force_update, false)
  recreate_pods = try(each.value.recreate_pods, false)
  dynamic "set" {
    for_each = try(each.value.set, [])

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  values = [try(file("${local.file_path}/${each.value.values}"), "")]

  depends_on = [module.k8s_namespace]
}