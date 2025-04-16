output "id" {
  description = "적용된 Kubernetes 리소스의 ID입니다."
  value       = kubectl_manifest.this.id
}

output "name" {
  description = "적용된 Kubernetes 리소스의 이름입니다."
  value       = kubectl_manifest.this.name
}

output "namespace" {
  description = "적용된 Kubernetes 리소스의 네임스페이스입니다."
  value       = kubectl_manifest.this.namespace
}

output "api_version" {
  description = "적용된 Kubernetes 리소스의 API 버전입니다."
  value       = kubectl_manifest.this.api_version
}

output "kind" {
  description = "적용된 Kubernetes 리소스의 종류(Kind)입니다."
  value       = kubectl_manifest.this.kind
}

output "uid" {
  description = "적용된 리소스의 UID입니다."
  value       = kubectl_manifest.this.uid
}
