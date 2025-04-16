output "id" {
  description = "생성된 네임스페이스의 고유 ID. Kubernetes 리소스에서 네임스페이스를 식별하기 위해 사용됩니다."
  value       = kubernetes_namespace.namespace.id
}

output "name" {
  description = "생성된 네임스페이스의 이름. 클러스터 내에서 네임스페이스를 고유하게 식별하는 데 사용됩니다."
  value       = kubernetes_namespace.namespace.metadata[0].name
}