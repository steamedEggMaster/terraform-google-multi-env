output "id" {
  description = "생성된 서비스 계정의 고유 ID. Kubernetes 리소스에서 해당 서비스 계정을 식별하기 위해 사용됩니다."
  value       = kubernetes_service_account.service_account.id
}

output "name" {
  description = "생성된 서비스 계정의 이름. 클러스터 내에서 서비스 계정을 고유하게 식별하는 데 사용됩니다."
  value       = kubernetes_service_account.service_account.metadata[0].name
}

output "namespace" {
  description = "생성된 서비스 계정이 속한 네임스페이스의 이름. 서비스 계정이 생성된 네임스페이스를 나타냅니다."
  value       = kubernetes_service_account.service_account.metadata[0].namespace
}
