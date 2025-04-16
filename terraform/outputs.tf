output "all_vm_ips" {
  description = "External IP of the DB VM Instance"
  value = {
    for vm_name, vm in google_compute_instance.this :
    vm_name => {
      private_ip = try(vm.network_interface[0].network_ip, "private_ip가 없습니다.")
      public_ip  = try(vm.network_interface[0].access_config[0].nat_ip, "public_ip가 없습니다.")
    }
  }
}

output "nginx_ingress_ip" {
  description = "External IP of the Nginx Ingress Controller"
  value       = try(data.kubernetes_service.nginx_ingress[0].status[0].load_balancer[0].ingress[0].ip, "ingress-nginx가 없습니다")
}

output "database_ips" {
  description = "List of all created database private and public IPs"
  value = {
    for db_name, db in module.database :
    db_name => {
      private_ip = try(db.private_ip_address, "private_ip가 없습니다.")
      public_ip  = try(db.public_ip_address, "public_ip가 없습니다.")
    }
  }
}

output "db_cert" {
  description = "List of all created ssl cert for ssl connection with database"
  value = try({
    for key, value in google_sql_ssl_cert.this :
    value.instance => {
      server_ca_cert = try(value.server_ca_cert, "server_ca_cert가 없습니다.")
    }
  }, "database가 없습니다.")
  sensitive = true
}

output "redis_master_ip" {
  description = "redis_master ip"
  value       = try(data.kubernetes_service.redis_master[0].status[0].load_balancer[0].ingress[0].ip, "redis-master가 LoadBalancer가 아닙니다.")
}