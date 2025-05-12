module "api" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-project-factory.git//modules/project_services?ref=v1.0.0"

  for_each = var.api

  project_id                  = each.key
  enable_apis                 = try(each.value.enable_apis, true)
  activate_apis               = try(each.value.activate_apis, [])
  disable_services_on_destroy = try(each.value.disable_services_on_destroy, false)
  disable_dependent_services  = try(each.value.disable_dependent_services, false)
}

module "network" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-network.git?ref=v1.0.0"

  for_each = var.network

  project_id                             = each.value.project_id
  network_name                           = each.key
  routing_mode                           = try(each.value.routing_mode, "REGIONAL")
  auto_create_subnetworks                = try(each.value.auto_create_subnetworks, false)
  mtu                                    = try(each.value.mtu, 0)
  delete_default_internet_gateway_routes = try(each.value.delete_default_internet_gateway_routes, false)

  subnets = [for subnet in try(each.value.subnets, []) : {
    subnet_name           = subnet.subnet_name
    subnet_ip             = subnet.subnet_ip
    subnet_region         = subnet.subnet_region
    description           = try(subnet.description, "")
    subnet_private_access = try(subnet.subnet_private_access, "false")
    stack_type            = try(subnet.stack_type, "IPV4_ONLY")
  }]
  ## 객체 안, key = list 구조...
  secondary_ranges = try(each.value.secondary_ranges, {})
  #   ~ = [{
  #        range_name = ""
  #        ip_cidr_range = ""
  #     },
  #   ]

  ingress_rules = [for ingress_rule in try(each.value.ingress_rules, []) : {
    name          = ingress_rule.name
    description   = try(ingress_rule.description, "")
    source_ranges = try(ingress_rule.source_ranges, [])
    allow = [for allow in try(ingress_rule.allow, []) : {
      protocol = allow.protocol
      ports    = try(allow.ports, [])
    }]
  }]

  depends_on = [module.api]
}

module "ip" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-address.git?ref=v1.0.0"

  for_each = var.ip

  project_id   = each.value.project_id
  region       = each.value.region
  names        = try(each.value.names, [])
  global       = try(each.value.global, false)
  descriptions = try(each.value.descriptions, [])
  address_type = try(each.value.address_type, "EXTERNAL") ## INTERNAL
  network_tier = try(each.value.network_tier, "PREMIUM")
  ip_version   = try(each.value.ip_version, "IPV4")

  depends_on = [module.network]
}

module "nat" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-cloud-nat.git?ref=v1.0.0"

  for_each = var.nat

  project_id    = each.value.project_id
  create_router = try(each.value.create_router, false)
  router        = each.value.router
  region        = each.value.region
  network       = module.network[each.value.network].network_self_link

  name                               = each.key
  source_subnetwork_ip_ranges_to_nat = try(each.value.source_subnetwork_ip_ranges_to_nat, "LIST_OF_SUBNETWORKS")
  subnetworks = [for subnetwork in try(each.value.subnetworks, []) : {
    name                     = module.network[each.value.network].subnets_self_links[index(module.network[each.value.network].subnets_names, subnetwork.name)]
    source_ip_ranges_to_nat  = subnetwork.source_ip_ranges_to_nat
    secondary_ip_range_names = try(subnetwork.secondary_ip_range_names, []) ## source_ip_ranges_to_nat 에 LIST_OF_SECONDARY_IP_RANGES가 있다면 사용
  }]
  nat_ips = concat(
    [
      for ip_name in each.value.ip_names :
      "https://www.googleapis.com/compute/v1/projects/${each.value.project_id}/regions/${each.value.region}/addresses/${ip_name}"
    ]
    ,
  try(each.value.nat_ips, []))


  depends_on = [module.ip]
}

module "gke" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/terraform-google-kubernetes-engine.git//modules/private-cluster?ref=v1.0.0"
  ## private-cluster

  for_each = var.gke

  project_id = each.value.project_id
  name       = each.key
  #### Regional Cluster(지역적 클러스터) 생성 시 사용
  regional = try(each.value.regional, false)
  region   = try(each.value.region, "asia-northeast3")
  #### ==========================
  ## Zonal Cluster(단일 가용 영역 클러스터) 생성 시 사용 -> 1개의 zone만 설정하면 됨 (location).
  zones = try(each.value.zones, ["asia-northeast3-a"])
  ## =======================
  description = try(each.value.description, "")
  network     = each.value.network
  subnetwork  = each.value.subnetwork

  remove_default_node_pool = try(each.value.remove_default_node_pool, false)
  initial_node_count       = try(each.value.initial_node_count, 0)

  deletion_protection = try(each.value.deletion_protection, true)

  create_service_account = try(each.value.create_service_account, true)
  service_account        = try(each.value.service_account, "")
  service_account_name   = try(each.value.service_account_name, "")

  monitoring_enable_managed_prometheus = try(each.value.monitoring_enable_managed_prometheus, false)

  ## google logging service 차단 -> 금액 절약 -> Prometheus 사용
  ## 이걸 차단해도, 모듈에서 제공하는 service account가 생성되면 로깅을 보냄. (위의 argument)
  logging_service    = try(each.value.logging_service, "logging.googleapis.com/kubernetes")       ## none
  monitoring_service = try(each.value.monitoring_service, "monitoring.googleapis.com/kubernetes") ## none

  ## addons_config
  http_load_balancing        = try(each.value.http_load_balancing, true)
  horizontal_pod_autoscaling = try(each.value.horizontal_pod_autoscaling, true)
  gce_pd_csi_driver          = try(each.value.gce_pd_csi_driver, true)

  ## release_channel
  release_channel = try(each.value.release_channel, "REGULAR")

  ## Workload Identity
  identity_namespace = try(each.value.identity_namespace, "enabled") ## "enabled" 이면 {project_id}.svc.id.goog 형식 사용 

  ## ip_allocation_policy 필수 설정!
  ip_range_pods     = each.value.ip_range_pods
  ip_range_services = each.value.ip_range_services

  ## private_cluster_config
  enable_private_nodes    = try(each.value.enable_private_nodes, true)
  enable_private_endpoint = try(each.value.enable_private_endpoint, false)
  master_ipv4_cidr_block  = try(each.value.master_ipv4_cidr_block, null)

  ## node_pool ======================================
  node_pools = [for node_pool in try(each.value.node_pools, []) : {
    name        = node_pool.name
    autoscaling = try(node_pool.autoscaling, true)
    node_count  = try(node_pool.node_count, 1) ## Autoscaling가 false일때 반드시 설정해야하는 고정된 노드 개수

    ## Autoscaling 사용 시 ======================
    initial_node_count = try(node_pool.initial_node_count, 1) ## Autoscaling 사용 시 시작 노드 개수 (이후 변화 개수와 상관 X)
    min_count          = try(node_pool.min_count, 1)          ## 각 Zone 별 최소 노드 개수
    max_count          = try(node_pool.max_count, 1)
    total_min_count    = try(node_pool.total_min_count, 1) # 클러스터 내부 모든 최소 노드 개수 
    total_max_count    = try(node_pool.total_max_count, 1)
    ## ========================================

    ## mangement
    auto_repair  = try(node_pool.auto_repair, true)
    auto_upgrade = try(node_pool.auto_upgrade, true) ## regional cluster 시 true

    ## node_config
    preemptible  = try(node_pool.preemptible, false)
    spot         = try(node_pool.spot, false)
    machine_type = try(node_pool.machine_type, "e2-medium")
    disk_size_gb = try(node_pool.disk_size_gb, 100)

    service_account = try(node_pool.service_account, null)
    ## null일 경우 자동으로 생성된 service account가 node pool의 service account가 됨
  }]

  ## labels
  node_pools_labels = try(merge(
    {
      default_values = try(each.value.node_pools_labels.default_values, {})
      all            = try(each.value.node_pools_labels.all, {})
    },
    try(each.value.node_pools_labels.node_pools, {})
  ))
  # all = {
  #   { ~ = ~ }
  # }
  # "node_pool_name1" = {
  #   { ~ = ~ }
  # }

  ## taint
  node_pools_taints = try(merge(
    {
      all = try(each.value.node_pools_taints.all, [])
    },
    try(each.value.node_pools_taints.node_pools, {})
  ), {})
  # all = [               ## 모든 node_pool에 설정할 taint
  #   {
  #     key    = ""
  #     value  = ""
  #     effect = "" ## NO_SCHEDULE | PREFER_NO_SCHEDULE | NO_EXECUTE
  #   },
  # ]
  # "node_pool_name1" = [ ## 특정 node_pool에 설정할 taint
  #   {
  #     key    = ""
  #     value  = ""
  #     effect = ""
  #   },
  # ]

  node_pools_tags = try(merge(
    {
      all = try(each.value.node_pools_tags.all, [])
    },
    try(each.value.node_pools_tags.node_pools, {})
  ))

  node_pools_oauth_scopes = try(merge(
    {
      all = try(each.value.node_pools_oauth_scopes.all, [])
    },
    try(each.value.node_pools_oauth_scopes.node_pools, {})
  ))
  # "node_pool_name1" = [] ## 특정 node_pool에 설정할 oauth_scopes 리스트
  # 기본으로 all = ["https://www.googleapis.com/auth/cloud-platform"] 이 존재

  depends_on = [module.api, module.nat]
}