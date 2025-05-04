module "database" {
  source = "../../../../../modules/gcp/database"

  for_each = local.yaml.yaml_data.database

  project_id          = each.value.project_id
  region              = try(each.value.region, "asia-northeast3")
  database_engine     = each.value.database_engine
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
  # ipv4_enabled                                  = optional(bool, true)
  # private_network                               = optional(string) ## VPC self_link
  ## ========= 추가로 알아보기 ============
  # ssl_mode                                      = optional(string) ## "ENCRYPTED_ONLY" 또는 "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  # allocated_ip_range                            = optional(string)
  # enable_private_path_for_google_cloud_services = optional(bool, false)
  ## ==================================
  # authorized_networks = [
  #   {
  #     expiration_time = lookup(authorized_networks.value, "expiration_time", null)
  #     name            = lookup(authorized_networks.value, "name", null)
  #     value           = lookup(authorized_networks.value, "value", null)
  #   } 
  # ]
  insights_config = try(each.value.insights_config, null) ## 설정하는 순간 true로 적용됨
  ## ========= 추가로 알아보기 ============
  # query_plans_per_minute  = optional(number, 5)
  # query_string_length     = optional(number, 1024)
  # record_application_tags = optional(bool, false)
  # record_client_address   = optional(bool, false)
  ## ==================================

  db_name    = try(each.value.db_name, "default")
  db_charset = try(each.value.db_charset, "") # 문자셋(문자 저장 방식)
  # db_collation = try(each.value.db_collation, "ko_KR.UTF8") # 문자 비교 및 정렬 방식

  user_name     = try(each.value.user_name, "default")
  user_password = try(each.value.user_password, "")

  depends_on = [module.private_service_access]
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

module "private_service_access" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-sql-db.git//modules/private_service_access?ref=v1.0.0"

  for_each = local.yaml.yaml_data.database_psa

  project_id      = each.value.project_id
  vpc_network     = each.value.vpc_network
  address         = try(each.value.address, "")
  description     = try(each.value.description, "")
  prefix_length   = try(each.value.prefix_length, 16)
  ip_version      = try(each.value.ip_version, "IPV4")
  labels          = try(each.value.labels, {})
  deletion_policy = try(each.value.deletion_policy, null)

  depends_on = [module.private_cluster]
}