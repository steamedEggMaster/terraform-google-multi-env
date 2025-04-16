

resource "kubernetes_namespace" "namespace" {
  metadata {
    name        = var.name        # 네임스페이스 이름. var.name 변수에서 값을 가져옵니다.
    annotations = var.annotations # 네임스페이스에 추가할 주석(annotations). key-value 쌍으로 이루어진 map 형식입니다.
    labels      = var.labels      # 네임스페이스에 추가할 레이블(labels). 리소스를 분류하고 선택하는 데 사용됩니다.
  }

  timeouts {
    delete = var.delete_timeout # 네임스페이스 삭제 작업에 대한 타임아웃 시간. 기본값은 5분으로 설정될 수 있습니다.
  }

  wait_for_default_service_account = var.wait_for_default_service_account # 기본 서비스 계정 생성 여부를 대기할지 설정. true이면 대기, false이면 대기하지 않음.
}
