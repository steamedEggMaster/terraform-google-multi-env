module "private_cluster" {
  source = "../../../../../modules/private_cluster"

  for_each = local.yaml

  api     = each.value.api
  network = try(each.value.network, {})
  ip      = try(each.value.ip, {})
  nat     = try(each.value.nat, {})
  gke     = try(each.value.gke, {})
}

module "service_account" {
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

  depends_on = [module.service_account, module.k8s_sa]
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

  depends_on = [module.service_account, module.registry]
}

module "storage_bucket_iam" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-iam.git//modules/storage_buckets_iam?ref=v1.0.0"

  for_each = local.yaml.yaml_data.sb_iam

  storage_buckets = try(each.value.storage_buckets, [])
  mode            = try(each.value.mode, "additive")
  bindings        = try(each.value.bindings, {})

  depends_on = [module.service_account, module.bucket]
}

module "database" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-sql-db.git//modules/postgresql?ref=v1.0.0"
  ## postgresql

  for_each = local.yaml.yaml_data.database

  project_id          = each.value.project_id
  region              = try(each.value.region, "asia-northeast3")
  name                = each.key
  database_version    = each.value.database_version
  deletion_protection = try(each.value.deletion_protection, false)

  tier           = try(each.value.tier, "db-f1-micro")
  disk_size      = try(each.value.disk_size, 10) ## GB
  disk_type      = try(each.value.disk_type, "PD_SSD")
  database_flags = try(each.value.database_flags, [])
  # {
  #   name  = ""
  #   value = ""
  # }
  backup_configuration = try(each.value.backup_configuration, {})
  # enabled                        = optional(bool, false)
  # start_time                     = optional(string)
  # location                       = optional(string)
  # point_in_time_recovery_enabled = optional(bool, false)
  # transaction_log_retention_days = optional(string)
  # retained_backups               = optional(number)
  # retention_unit                 = optional(string)
  ip_configuration = try(each.value.ip_configuration, {})
  insights_config = try(each.value.insights_config, null) ## 설정하는 순간 true로 적용됨
  # {
  #   query_plans_per_minute  = optional(number, 5)
  #   query_string_length     = optional(number, 1024)
  #   record_application_tags = optional(bool, false)
  #   record_client_address   = optional(bool, false)
  # }
  
  db_name    = try(each.value.db_name, "default")
  db_charset = try(each.value.db_charset, "") # 문자셋(문자 저장 방식)

  user_name     = try(each.value.user_name, "default")
  user_password = try(each.value.user_password, "")

  depends_on = [module.private_cluster]
}

resource "google_sql_ssl_cert" "this" {
  for_each = {
    for k, v in local.yaml.yaml_data.database :
    k => v if lookup(v.ip_configuration, "ssl_mode", "") == "ENCRYPTED_ONLY"
  }

  instance    = each.value.name        # Cloud SQL 인스턴스 이름
  common_name = each.value.common_name # 클라이언트 인증서의 Common Name (CN) ## 자유롭게 설정하기(나를 판별하기 위함)
  project     = each.value.project_id

  depends_on = [module.database]
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

  depends_on = [module.private_cluster]
}