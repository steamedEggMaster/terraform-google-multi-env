data "google_client_config" "current" {}

######################################
## main
######################################

# 생성한 GKE에 연결하기 위한 data resource
data "google_container_cluster" "gke" {
  count = lookup(local.yaml.yaml_data.provider.main, "gke_name", "") != "" ? 1 : 0

  project  = local.yaml.yaml_data.provider.main.project
  name     = try(local.yaml.yaml_data.provider.main.gke_name, null)
  location = local.yaml.yaml_data.provider.main.gke_location
}

# Ingress-Nginx의 External IP를 가져오기 위한 data resource
data "kubernetes_service" "nginx_ingress" {
  count = lookup(local.yaml.yaml_data.provider.main, "nginx_service_name", "") != "" ? 1 : 0

  metadata {
    name      = try(local.yaml.yaml_data.provider.main.nginx_service_name, null)
    namespace = local.yaml.yaml_data.provider.main.nginx_service_namespace
  }

  depends_on = [helm_release.this]
}

# Redis_Master의 External IP를 가져오기 위한 data resource
data "kubernetes_service" "redis_master" {
  count = lookup(local.yaml.yaml_data.provider.main, "redis_service_name", "") != "" ? 1 : 0

  metadata {
    name      = try(local.yaml.yaml_data.provider.main.redis_service_name, null)
    namespace = local.yaml.yaml_data.provider.main.redis_service_namespace
  }

  depends_on = [helm_release.this]
}