variable "yaml_body" {
  description = "Kubernetes에 적용할 YAML입니다."
  type        = string
}

variable "sensitive_fields" {
  description = "출력 시 숨겨야 하는 민감한 필드 목록(점 표기법 사용). 기본값은 Secrets의 'data' 필드입니다."
  type        = list(string)
  default     = ["data"]
}

variable "force_new" {
  description = "yaml_body가 변경될 경우 리소스를 삭제 후 새로 생성하도록 강제합니다."
  type        = bool
  default     = false
}

variable "server_side_apply" {
  description = "서버 측 적용(server-side apply) 방식을 사용할지 여부를 설정합니다."
  type        = bool
  default     = false
}

variable "force_conflicts" {
  description = "리소스 적용 시 충돌을 강제로 해결할지 여부를 설정합니다."
  type        = bool
  default     = false
}

variable "apply_only" {
  description = "리소스를 삭제하지 않고 적용만 수행하도록 설정합니다."
  type        = bool
  default     = false
}

variable "ignore_fields" {
  description = "리소스를 적용할 때 무시할 필드 목록을 설정합니다."
  type        = list(string)
  default     = []
}

variable "override_namespace" {
  description = "yaml_body에 선언된 네임스페이스를 무시하고, 지정한 네임스페이스로 리소스를 적용합니다."
  type        = string
  default     = null
}

variable "validate_schema" {
  description = "false로 설정하면 'kubectl apply --validate=false'와 동일하게 동작합니다."
  type        = bool
  default     = true
}

variable "wait" {
  description = "리소스를 삭제할 때 완료될 때까지 대기할지 여부를 설정합니다."
  type        = bool
  default     = false
}

variable "wait_for_rollout" {
  description = "Deployment 및 APIService가 롤아웃 완료될 때까지 대기할지 여부를 설정합니다."
  type        = bool
  default     = true
}
