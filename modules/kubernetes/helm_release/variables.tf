variable "name" {
  description = "설치할 Helm 릴리스의 이름"
  type        = string
}

variable "chart" {
  description = "설치할 Helm 차트의 경로 또는 이름"
  type        = string
}

variable "atomic" {
  description = "설치가 실패하면 자동으로 롤백할지 여부 (true이면 롤백)"
  type        = bool
  default     = false
}

variable "cleanup_on_fail" {
  description = "설치 또는 업그레이드가 실패하면 중간 생성된 리소스를 정리할지 여부"
  type        = bool
  default     = false
}

variable "create_namespace" {
  description = "네임스페이스가 존재하지 않을 경우 자동 생성할지 여부"
  type        = bool
  default     = false
}

variable "dependency_update" {
  description = "차트를 설치하기 전에 종속성 업데이트를 수행할지 여부"
  type        = bool
  default     = false
}

variable "description" {
  description = "Helm 릴리스의 설명"
  type        = string
  default     = ""
}

variable "devel" {
  description = "개발 버전 차트를 허용할지 여부"
  type        = bool
  default     = false
}

variable "disable_crd_hooks" {
  description = "CRD 관련 훅을 비활성화할지 여부"
  type        = bool
  default     = false
}

variable "disable_openapi_validation" {
  description = "OpenAPI 스키마 검증을 비활성화할지 여부"
  type        = bool
  default     = false
}

variable "disable_webhooks" {
  description = "웹훅 실행을 비활성화할지 여부"
  type        = bool
  default     = false
}

variable "force_update" {
  description = "차트 업그레이드시 강제 업데이트 여부"
  type        = bool
  default     = false
}

variable "keyring" {
  description = "서명된 차트의 검증을 위한 키링 경로"
  type        = string
  default     = ""
}

variable "lint" {
  description = "Helm 린트(lint) 검사를 실행할지 여부"
  type        = bool
  default     = false
}

variable "max_history" {
  description = "Helm 릴리스의 최대 기록 개수"
  type        = number
  default     = 10
}

variable "namespace" {
  description = "Helm 릴리스가 배포될 네임스페이스"
  type        = string
}

variable "pass_credentials" {
  description = "레지스트리 인증 정보를 저장할지 여부"
  type        = bool
  default     = false
}

variable "postrender" {
  description = "Helm 차트가 렌더링된 후 실행할 후처리 스크립트"
  type = object({
    binary_path = string
    args        = optional(list(string), [])
  })
  default = null
}

variable "recreate_pods" {
  description = "업그레이드시 모든 파드를 다시 생성할지 여부"
  type        = bool
  default     = false
}

variable "render_subchart_notes" {
  description = "서브차트의 노트를 렌더링할지 여부"
  type        = bool
  default     = false
}

variable "replace" {
  description = "릴리스를 새로 만들고 기존 릴리스를 대체할지 여부"
  type        = bool
  default     = false
}

variable "repository" {
  description = "Helm 차트의 저장소 URL"
  type        = string
  default     = ""
}

variable "repository_ca_file" {
  description = "차트 저장소의 CA 인증서 경로"
  type        = string
  default     = ""
}

variable "repository_cert_file" {
  description = "차트 저장소 인증서 파일 경로"
  type        = string
  default     = ""
}

variable "repository_key_file" {
  description = "차트 저장소 인증 키 파일 경로"
  type        = string
  default     = ""
}

variable "repository_password" {
  description = "차트 저장소에 대한 비밀번호"
  type        = string
  default     = ""
}

variable "repository_username" {
  description = "차트 저장소에 대한 사용자 이름"
  type        = string
  default     = ""
}

variable "reset_values" {
  description = "업그레이드시 이전 값을 재설정할지 여부"
  type        = bool
  default     = false
}

variable "reuse_values" {
  description = "업그레이드시 이전 값을 다시 사용할지 여부"
  type        = bool
  default     = false
}

variable "set" {
  description = "Helm 차트의 설정 값"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "set_list" {
  description = "Helm 차트 설정 값을 리스트로 설정"
  type = list(object({
    name  = string
    value = list(string)
  }))
  default = []
}

variable "set_sensitive" {
  description = "민감한 Helm 설정 값을 설정"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "skip_crds" {
  description = "Helm 차트 설치 시 CRD 생성을 건너뛸지 여부"
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Helm 명령 실행 타임아웃(초 단위)"
  type        = number
  default     = 300
}

variable "upgrade_install" {
  description = "차트가 존재하지 않으면 설치하도록 설정할지 여부"
  type        = bool
  default     = true
}

variable "values" {
  description = "Helm 차트의 values.yaml 설정 파일 목록"
  type        = list(string)
  default     = []
}

variable "verify" {
  description = "차트 검증을 활성화할지 여부"
  type        = bool
  default     = false
}

variable "chart_version" {
  description = "설치할 Helm 차트의 버전"
  type        = string
  default     = ""
}

variable "wait" {
  description = "모든 리소스가 준비될 때까지 대기할지 여부"
  type        = bool
  default     = true
}

variable "wait_for_jobs" {
  description = "모든 Job이 완료될 때까지 대기할지 여부"
  type        = bool
  default     = false
}
