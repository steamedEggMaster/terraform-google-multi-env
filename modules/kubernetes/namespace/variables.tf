variable "name" {
  description = "생성할 Kubernetes 네임스페이스의 이름. 네임스페이스 이름은 클러스터 내에서 고유해야 하며, 변경할 수 없습니다."
  type        = string
}

variable "annotations" {
  description = "네임스페이스에 추가할 주석(annotations). 주석은 key-value 형태의 비구조적 데이터로, 사용자 정의 메타데이터를 저장하는 데 사용됩니다."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "네임스페이스에 추가할 레이블(labels). 레이블은 리소스를 분류하거나 선택하기 위해 key-value 형태로 제공되며, 서비스나 컨트롤러와의 연결에 유용합니다."
  type        = map(string)
  default     = {}
}

variable "delete_timeout" {
  description = "네임스페이스 삭제 작업에 대한 타임아웃 시간. 지정된 시간이 초과되면 삭제 작업이 실패로 간주됩니다. 기본값은 5분(5m)입니다."
  type        = string
  default     = "5m"
}

variable "wait_for_default_service_account" {
  description = "네임스페이스 생성 시 기본 서비스 계정(default service account)이 생성될 때까지 대기할지 여부를 설정합니다. true이면 대기하고, false이면 대기하지 않습니다."
  type        = bool
  default     = true
}
