variable "api" {
  description = "API를 활성화하는 변수"
  type = map(object({
    project_id                  = string
    enable_apis                 = optional(bool, true)
    activate_apis               = optional(list(string), [])
    disable_services_on_destroy = optional(bool, false)
    disable_dependent_services  = optional(bool, false)
  }))
  default = {}
}

variable "network" {
  description = "Network 설정을 위한 변수"
  type = map(object({
    project_id                             = string
    network_name                           = string
    routing_mode                           = optional(string, "REGIONAL")
    auto_create_subnetworks                = optional(bool, false)
    mtu                                    = optional(number, 1460)
    delete_default_internet_gateway_routes = optional(bool, false)

    subnets = optional(list(object({
      subnet_name           = string
      subnet_ip             = string
      subnet_region         = string
      description           = optional(string, "")
      subnet_private_access = optional(string, "false")
      stack_type            = optional(string, "IPV4_ONLY")
      ipv6_access_type      = optional(string, null)
    })), [])

    secondary_ranges = optional(map(list(object({
      range_name    = string
      ip_cidr_range = string
    }))), {})

    egress_rules = optional(list(object({
      name               = string
      description        = optional(string, "")
      priority           = optional(number, null)
      destination_ranges = optional(list(string), [])
      source_ranges      = optional(list(string), [])
      allow = optional(list(object({
        protocol = string
        ports    = optional(list(string), [])
      })), [])
      deny = optional(list(object({
        protocol = string
        ports    = optional(list(string), [])
      })), [])
    })), [])

    ingress_rules = optional(list(object({
      name               = string
      description        = optional(string, "")
      priority           = optional(number, null)
      destination_ranges = optional(list(string), [])
      source_ranges      = optional(list(string), [])
      allow = optional(list(object({
        protocol = string
        ports    = optional(list(string), [])
      })), [])
      deny = optional(list(object({
        protocol = string
        ports    = optional(list(string), [])
      })), [])
    })), [])
  }))
  default = {}
}

variable "ip" {
  description = "ip 설정을 위한 변수"
  type = map(object({
    project_id   = string
    region       = string
    names        = optional(list(string), [])
    global       = optional(bool, false)
    descriptions = optional(list(string), [])
    address_type = optional(string, "EXTERNAL")
    network_tier = optional(string, "PREMIUM")
    ip_version   = optional(string, "IPV4")
  }))
  default = {}
}

variable "nat" {
  description = "nat 설정을 위한 변수"
  type = map(object({
    project_id    = string
    create_router = optional(bool, false)
    router        = string
    region        = string
    network       = string

    name                               = string
    source_subnetwork_ip_ranges_to_nat = optional(string, "LIST_OF_SUBNETWORKS")
    subnetworks = optional(list(object({
      name                     = string
      source_ip_ranges_to_nat  = list(string)
      secondary_ip_range_names = optional(list(string), [])
    })), [])
    ip_names = optional(list(string), [])
    nat_ips  = optional(list(string), [])
  }))
  default = {}
}

variable "gke" {
  description = "gke 설정을 위한 변수"
  type = map(object({
    project_id  = string
    name        = string
    regional    = optional(bool, false)
    region      = optional(string, "asia-northeast3")
    zones       = optional(list(string), ["asia-northeast3-a"])
    description = optional(string, "")
    network     = string
    subnetwork  = string

    remove_default_node_pool = optional(bool, true)
    initial_node_count       = optional(number, 1)
    deletion_protection      = optional(bool, false)

    create_service_account = optional(bool, true)
    service_account        = optional(string, "")
    service_account_name   = optional(string, "")

    monitoring_enable_managed_prometheus = optional(bool, false)

    logging_service    = optional(string, "none")
    monitoring_service = optional(string, "none")

    enable_l4_ilb_subsetting = optional(bool, false)

    http_load_balancing        = optional(bool, false)
    horizontal_pod_autoscaling = optional(bool, true)
    gce_pd_csi_driver          = optional(bool, true)

    release_channel = optional(string, "REGULAR")

    identity_namespace = optional(string, "enabled")

    datapath_provider = optional(string, "DATAPATH_PROVIDER_UNSPECIFIED")

    ip_range_pods     = string
    ip_range_services = string
    stack_type        = optional(string, "IPV4")

    cluster_dns_provider          = optional(string, "PROVIDER_UNSPECIFIED")
    cluster_dns_scope             = optional(string, "DNS_SCOPE_UNSPECIFIED")
    cluster_dns_domain            = optional(string, "")
    additive_vpc_scope_dns_domain = optional(string, "")

    enable_private_nodes    = optional(bool, true)
    enable_private_endpoint = optional(bool, false)
    master_ipv4_cidr_block  = optional(string, null)

    node_pools = optional(list(object({
      name        = string
      autoscaling = optional(bool, true)
      node_count  = optional(number, 1)

      initial_node_count = optional(number, 1)
      min_count          = optional(number, 1)
      max_count          = optional(number, 1)
      total_min_count    = optional(number, 1)
      total_max_count    = optional(number, 1)

      auto_repair  = optional(bool, true)
      auto_upgrade = optional(bool, true)

      preemptible  = optional(bool, false)
      spot         = optional(bool, false)
      machine_type = optional(string, "e2-medium")
      disk_size_gb = optional(number, 20)

      service_account = optional(string, null)
    })), [])

    node_pools_labels = optional(object({
      default_values = optional(object({
        cluster_name = optional(bool, false)
        node_pool    = optional(bool, false)
      }), {})
      all        = optional(map(string), {})
      node_pools = optional(map(map(string)), {})
    }), {})

    node_pools_taints = optional(object({
      all = optional(list(object({
        key    = string
        value  = string
        effect = string
      })), [])
      node_pools = optional(map(list(object({
        key    = string
        value  = string
        effect = string
      }))), {})
    }), {})

    node_pools_tags = optional(object({
      all        = optional(list(string), [])
      node_pools = optional(map(list(string)), {})
    }), {})

    node_pools_oauth_scopes = optional(object({
      all        = optional(list(string), [])
      node_pools = optional(map(list(string)), {})
    }), {})

  }))
  default = {}
}