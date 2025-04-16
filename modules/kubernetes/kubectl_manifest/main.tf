resource "kubectl_manifest" "this" {
  # 필수 설정
  yaml_body = var.yaml_body

  # 보안 및 충돌 해결 관련 설정
  sensitive_fields = var.sensitive_fields
  force_conflicts  = var.force_conflicts
  validate_schema  = var.validate_schema

  # 적용 방식 관련 설정
  server_side_apply  = var.server_side_apply
  apply_only         = var.apply_only
  force_new          = var.force_new
  ignore_fields      = var.ignore_fields
  override_namespace = var.override_namespace

  # 리소스 적용 후 대기 관련 설정
  wait             = var.wait
  wait_for_rollout = var.wait_for_rollout
}
