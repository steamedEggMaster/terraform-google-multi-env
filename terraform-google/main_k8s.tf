module "k8s_namespace" {
  source = "../../../../../modules/kubernetes/namespace"

  for_each = local.yaml.yaml_data.k8s_namespace

  name        = each.value.name
  annotations = try(each.value.annotations, {})
  labels      = try(each.value.labels, {})

  depends_on = [module.private_cluster]
}

module "k8s_sa" {
  source = "../../../../../modules/kubernetes/service_account"

  for_each = local.yaml.yaml_data.k8s_sa

  name        = each.key
  namespace   = module.k8s_namespace[each.value.namespace].name
  annotations = try(each.value.annotations, {})
  labels      = try(each.value.labels, {})

  depends_on = [module.k8s_namespace]
}
