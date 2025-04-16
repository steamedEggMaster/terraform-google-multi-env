resource "kubernetes_service_account" "service_account" {
  metadata {
    name        = var.name        # 서비스 계정의 이름. var.name 변수에서 값을 가져옵니다.
    namespace   = var.namespace   # 서비스 계정을 생성할 네임스페이스. var.namespace 변수에서 값을 가져옵니다.
    annotations = var.annotations # 서비스 계정에 추가할 주석(annotations). key-value 형태로 메타데이터를 저장합니다.
    labels      = var.labels      # 서비스 계정에 추가할 레이블(labels). 리소스를 분류하고 선택하는 데 사용됩니다.
  }

  automount_service_account_token = var.automount_service_account_token # 서비스 계정 토큰을 자동으로 마운트할지 설정. true이면 자동 마운트, false이면 비활성화합니다.

  dynamic "image_pull_secret" { # 이미지 풀 시크릿(image pull secrets)을 동적으로 추가합니다.
    for_each = var.image_pull_secrets != null ? var.image_pull_secrets : []
    content {
      name = image_pull_secret.value # 이미지 풀 시크릿의 이름. 현재 순회 중인 시크릿 값에서 가져옵니다.
    }
  }

  dynamic "secret" { # 서비스 계정이 사용할 시크릿을 동적으로 추가합니다.
    for_each = var.secrets != null ? var.secrets : []
    content {
      name = secret.value # 서비스 계정에 연결할 시크릿의 이름. 현재 순회 중인 시크릿 값에서 가져옵니다.
    }
  }

  timeouts {
    create = var.create_timeout # 서비스 계정 생성 작업에 대한 타임아웃 시간. 지정된 시간이 초과되면 작업이 실패로 간주됩니다.
  }
}