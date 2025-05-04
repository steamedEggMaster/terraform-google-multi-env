######################################
## main
######################################
provider "google" {
  project = local.yaml.yaml_data.provider.main.project
  region  = local.yaml.yaml_data.provider.main.region
}

provider "kubernetes" {
  host                   = try("https://${data.google_container_cluster.gke[0].endpoint}", "")
  cluster_ca_certificate = try(base64decode(data.google_container_cluster.gke[0].master_auth.0.cluster_ca_certificate), "")
  token                  = try(data.google_client_config.current.access_token, "")
}

provider "helm" {
  kubernetes {
    host                   = try("https://${data.google_container_cluster.gke[0].endpoint}", "")
    cluster_ca_certificate = try(base64decode(data.google_container_cluster.gke[0].master_auth.0.cluster_ca_certificate), "")
    token                  = try(data.google_client_config.current.access_token, "")
  }
}

provider "kubectl" {
  host                   = try("https://${data.google_container_cluster.gke[0].endpoint}", "")
  cluster_ca_certificate = try(base64decode(data.google_container_cluster.gke[0].master_auth.0.cluster_ca_certificate), "")
  token                  = try(data.google_client_config.current.access_token, "")
}