terraform {
  # Terraform 버전 설정
  required_version = ">= 1.10.3" # 최소 1.10.3 이상의 Terraform 버전 사용

  # 필수 제공자 설정
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}