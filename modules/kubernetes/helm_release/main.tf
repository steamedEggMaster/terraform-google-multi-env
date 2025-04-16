resource "helm_release" "this" {
  # 필수 속성
  name        = var.name
  chart       = var.chart
  namespace   = var.namespace
  version     = var.chart_version
  description = var.description

  # 네임스페이스 & 리포지토리 관련 설정
  create_namespace     = var.create_namespace
  repository           = var.repository
  repository_ca_file   = var.repository_ca_file
  repository_cert_file = var.repository_cert_file
  repository_key_file  = var.repository_key_file
  repository_username  = var.repository_username
  repository_password  = var.repository_password

  # 설치 & 업그레이드 옵션
  atomic                     = var.atomic
  cleanup_on_fail            = var.cleanup_on_fail
  dependency_update          = var.dependency_update
  devel                      = var.devel
  disable_crd_hooks          = var.disable_crd_hooks
  disable_openapi_validation = var.disable_openapi_validation
  disable_webhooks           = var.disable_webhooks
  force_update               = var.force_update
  keyring                    = var.keyring
  lint                       = var.lint
  max_history                = var.max_history
  pass_credentials           = var.pass_credentials
  recreate_pods              = var.recreate_pods
  render_subchart_notes      = var.render_subchart_notes
  replace                    = var.replace
  reset_values               = var.reset_values
  reuse_values               = var.reuse_values
  skip_crds                  = var.skip_crds
  timeout                    = var.timeout
  upgrade_install            = var.upgrade_install
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs

  dynamic "postrender" {
    for_each = var.postrender != null ? [var.postrender] : []

    content {
      binary_path = postrender.value.binary_path
      args        = postrender.value.args
    }
  }

  dynamic "set" {
    for_each = var.set

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  dynamic "set_list" {
    for_each = var.set_list

    content {
      name  = set_list.value.name
      value = set_list.value.value
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = try(set_sensitive.value.type, null)
    }
  }

  # Helm values & 검증 옵션
  values = var.values
  verify = var.verify
}
