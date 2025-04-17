resource "google_compute_instance" "this" {
  for_each = local.yaml.yaml_data.vm

  name                      = each.value.name
  machine_type              = each.value.machine_type
  zone                      = each.value.zone
  allow_stopping_for_update = try(each.value.allow_stopping_for_update, false)
  desired_status            = try(each.value.desired_status, "RUNNING")
  deletion_protection       = try(each.value.deletion_protection, false)
  hostname                  = try(each.value.hostname, null)

  labels = try(each.value.labels, {})
  tags   = try(each.value.tags, []) # 방화벽 규칙에 사용될 네트워크 태그

  boot_disk {
    auto_delete = try(each.value.auto_delete, true)        # VM 삭제 시 부팅 디스크 자동 삭제 여부 (기본값: true)
    device_name = try(each.value.device_name, "boot-disk") # 부팅 디스크의 이름 (기본값: "boot-disk")
    mode        = try(each.value.mode, "READ_WRITE")       # 디스크 모드 (읽기/쓰기 가능)

    initialize_params {
      size                  = try(each.value.size, 100)                       # 부팅 디스크 크기 (GB, 기본값: 100GB)
      type                  = try(each.value.type, "pd-ssd")                  # 디스크 타입 ("pd-standard", "pd-ssd" 등)
      image                 = try(each.value.image, "debian-cloud/debian-11") # OS 이미지
      labels                = try(each.value.labels, {})                      # 디스크에 적용할 라벨
      resource_manager_tags = try(each.value.resource_manager_tags, {})       # 리소스 태그 (정책 적용용)
    }
  }

  dynamic "service_account" {
    for_each = try(each.value.service_account, [])
    content {
      email  = service_account.value.email                                                           # 사용할 서비스 계정 이메일
      scopes = try(service_account.value.scopes, ["https://www.googleapis.com/auth/cloud-platform"]) # API 접근 권한 범위 설정
    }
  }

  metadata                = try(each.value.metadata, {})                  # VM 메타데이터 (SSH 키, 사용자 지정 값)
  metadata_startup_script = try(each.value.metadata_startup_script, null) # VM 시작 시 실행할 스크립트

  network_interface {
    network    = each.value.network               # VM이 연결될 네트워크
    subnetwork = try(each.value.subnetwork, null) # 서브네트워크 설정 (자동 모드면 생략 가능)

    dynamic "access_config" {
      for_each = try(each.value.access_config, []) # 외부 IP 필요 시 추가
      content {
        nat_ip       = try(access_config.value.nat_ip, null)            # 외부 공개용 정적 IP (기본값: 자동 할당)
        network_tier = try(access_config.value.network_tier, "PREMIUM") # 네트워크 티어 설정
      }
    }
  }

  dynamic "scheduling" {
    for_each = try(each.value.scheduling, [{}]) # 스케줄링 설정이 없으면 기본값 적용
    content {
      preemptible                 = try(scheduling.value.preemptible, false)                # 선점형 VM 여부 (true: 저렴하지만 언제든 종료될 수 있음)
      on_host_maintenance         = try(scheduling.value.on_host_maintenance, "MIGRATE")    # 유지보수 시 동작 방식 (MIGRATE: 이동, TERMINATE: 종료)
      automatic_restart           = try(scheduling.value.automatic_restart, true)           # 자동 재시작 여부 (true: 활성화)
      provisioning_model          = try(scheduling.value.provisioning_model, "STANDARD")    # 프로비저닝 모델 ("STANDARD", "SPOT" 등)
      instance_termination_action = try(scheduling.value.instance_termination_action, null) # 인스턴스 종료 시 동작

      dynamic "on_instance_stop_action" {
        for_each = try(scheduling.value.on_instance_stop_action, []) # 중지 동작이 설정된 경우만 추가
        content {
          discard_local_ssd = try(on_instance_stop_action.value.discard_local_ssd, false) # 인스턴스 중지 시 로컬 SSD 삭제 여부
        }
      }
    }
  }

  dynamic "guest_accelerator" {
    for_each = try(each.value.guest_accelerator, []) # GPU가 설정된 경우에만 추가
    content {
      type  = guest_accelerator.value.type          # GPU 모델 (예: "nvidia-tesla-t4", "nvidia-tesla-v100" 등)
      count = try(guest_accelerator.value.count, 1) # GPU 개수 (기본값: 1)
    }
  }

  lifecycle {
    ignore_changes = [metadata_startup_script]
  }

  depends_on = [module.private_cluster, module.service_account]
}