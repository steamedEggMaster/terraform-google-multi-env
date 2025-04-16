output "release_name" {
  description = "배포된 Helm 릴리스의 이름"
  value       = helm_release.this.name
}

output "release_namespace" {
  description = "Helm 릴리스가 배포된 네임스페이스"
  value       = helm_release.this.namespace
}

output "release_version" {
  description = "배포된 Helm 릴리스의 버전"
  value       = helm_release.this.version
}

output "release_status" {
  description = "Helm 릴리스의 현재 상태"
  value       = helm_release.this.status
}

output "release_chart" {
  description = "사용된 Helm 차트의 이름"
  value       = helm_release.this.chart
}

output "release_manifest" {
  description = "Helm 릴리스의 매니페스트 출력"
  value       = helm_release.this.manifest
}

output "release_id" {
  description = "Helm 릴리스의 고유 ID"
  value       = helm_release.this.id
}

output "release_values" {
  description = "Helm 릴리스의 적용된 values"
  value       = helm_release.this.values
}

output "release_metadata" {
  description = "Helm 릴리스의 메타데이터"
  value       = helm_release.this.metadata
}
