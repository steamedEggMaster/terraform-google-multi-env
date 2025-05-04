locals {
  file_path = var.file_path
  map_env = {
    env = var.env
  }
  context = yamldecode(templatefile("${local.file_path}/context.yaml", local.map_env)).context

  files = {
    provider     = "1-provider.yaml"
    api          = "2-api.yaml"
    network      = "3-network.yaml"
    ip           = "4-ip.yaml"
    nat          = "5-nat.yaml"
    gke          = "6-gke.yaml"
    sa           = "7-sa.yaml"
    sa_iam       = "7-2-sa_iam.yaml"
    ar_iam       = "7-3-ar_iam.yaml"
    sb_iam       = "7-4-sb_iam.yaml"
    pj_iam       = "7-5-pj_iam.yaml"
    database     = "8-database.yaml"
    database_psa = "8-1-database_psa.yaml"
    registry     = "9-registry.yaml"
    bucket       = "10-bucket.yaml"

    k8s_namespace = "11-k8s_namespace.yaml"
    k8s_sa        = "11-2-k8s_sa.yaml"
    helm          = "12-helm.yaml"
    kubectl       = "13-kubectl.yaml"

    vm = "14-vm.yaml"
  }

  yaml = {
    yaml_data = {
      for key, filename in local.files :
      key => fileexists("${local.file_path}/${filename}") ?
      yamldecode(templatefile("${local.file_path}/${filename}", local.context))[key] != null ?
      yamldecode(templatefile("${local.file_path}/${filename}", local.context))[key] : tomap({})
      : tomap({})
    }
  }
}