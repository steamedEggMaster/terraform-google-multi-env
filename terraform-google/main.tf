module "private_cluster" {
  source = "../../../../../modules/gcp/private-cluster"

  for_each = local.yaml

  api     = each.value.api
  network = try(each.value.network, {})
  ip      = try(each.value.ip, {})
  nat     = try(each.value.nat, {})
  gke     = try(each.value.gke, {}) ## 더이상 sa 생성 후, gke를 생성하지 않아도 됨. 분리됨.
}

module "sa" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-service-accounts.git?ref=v1.0.0"

  for_each = local.yaml.yaml_data.sa

  project_id    = each.value.project_id
  prefix        = try(each.value.prefix, "")
  names         = try(each.value.names, [])
  project_roles = try(each.value.project_roles, [])

  depends_on = [module.private_cluster]
}

module "service_account_iam" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-iam.git//modules/service_accounts_iam?ref=v1.0.0"
  ## service_accounts_iam

  for_each = local.yaml.yaml_data.sa_iam

  project          = each.value.project
  service_accounts = try(each.value.service_accounts, [])
  mode             = try(each.value.mode, "additive")
  bindings         = try(each.value.bindings, {})
  # "세부역할" = [
  #   "member들"
  # ]
  # "" = [
  # ]
  conditional_bindings = try(each.value.conditional_bindings, [])
  # { ## 전부 필수
  #   role        = "" 
  #   title       = "" 
  #   description = "" 
  #   expression  = ""
  #   members = [
  #     ""
  #   ]
  # }

  depends_on = [module.sa, module.k8s_sa]
}

module "artifact_registry_iam" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-iam.git//modules/artifact_registry_iam?ref=v1.0.0"
  ## artifact_registry_iam

  for_each = local.yaml.yaml_data.ar_iam

  project      = each.value.project
  repositories = try(each.value.repositories, [])
  location     = each.value.location
  mode         = try(each.value.mode, "additive")
  bindings     = try(each.value.bindings, {})
  # "세부역할" = [
  #   "member들"
  # ]
  # "" = [
  # ]

  depends_on = [module.sa, module.registry]
}

module "storage_bucket_iam" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-iam.git//modules/storage_buckets_iam?ref=v1.0.0"

  for_each = local.yaml.yaml_data.sb_iam

  storage_buckets = try(each.value.storage_buckets, [])
  mode            = try(each.value.mode, "additive")
  bindings        = try(each.value.bindings, {})

  depends_on = [module.sa, module.bucket]
}

module "projects_iam" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-iam.git//modules/projects_iam?ref=v1.0.0"

  for_each = local.yaml.yaml_data.pj_iam

  projects             = try(each.value.projects, [])
  mode                 = try(each.value.mode, "additive")
  bindings             = try(each.value.bindings, {})
  conditional_bindings = try(each.value.conditional_bindings, [])

  depends_on = [module.sa, module.database]
}

module "registry" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-artifact-registry.git?ref=v1.0.0"

  for_each = local.yaml.yaml_data.registry

  project_id    = each.value.project_id
  repository_id = each.key
  location      = each.value.location
  format        = each.value.format
  description   = try(each.value.description, null)

  depends_on = [module.private_cluster]
}

module "bucket" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-cloud-storage.git?ref=v1.0.0"

  for_each = local.yaml.yaml_data.bucket

  project_id    = each.value.project_id
  names         = each.value.names
  location      = try(each.value.location, "ASIA-NORTHEAST3")
  force_destroy = try(each.value.force_destroy, {})
  # "bucket_name" = bool

  depends_on = [module.private_cluster]
}