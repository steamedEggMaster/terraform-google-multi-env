variable "name" {
  description = "생성할 Kubernetes 서비스 계정의 이름. 클러스터 내에서 고유해야 합니다."
  type        = string
}

variable "namespace" {
  description = "서비스 계정이 생성될 네임스페이스 이름. 해당 네임스페이스는 사전에 존재해야 합니다."
  type        = string
}

variable "annotations" {
  description = "서비스 계정에 추가할 주석(annotations). key-value 형식으로 사용자 정의 메타데이터를 저장합니다."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "서비스 계정에 추가할 레이블(labels). 리소스를 분류하거나 선택할 때 사용됩니다."
  type        = map(string)
  default     = {}
}

variable "automount_service_account_token" {
  description = "서비스 계정 토큰을 자동으로 마운트할지 여부를 설정합니다. true이면 자동 마운트되고, false이면 비활성화됩니다."
  type        = bool
  default     = true
}

variable "image_pull_secrets" {
  description = "서비스 계정이 사용할 이미지 풀 시크릿(image pull secrets)의 목록입니다. 각 항목은 시크릿 이름을 나타냅니다."
  type        = list(string)
  default     = []
}

variable "secrets" {
  description = "서비스 계정이 접근할 수 있는 시크릿(secret)의 목록입니다. 각 항목은 시크릿 이름을 나타냅니다."
  type        = list(string)
  default     = []
}

variable "create_timeout" {
  description = "서비스 계정 생성 작업의 타임아웃 시간. 지정된 시간이 초과되면 생성 작업이 실패로 간주됩니다."
  type        = string
  default     = "5m"
}