locals {
  file_path = "../../../config"
  env       = "dev"
}

terraform {
  source = "../../terraform-google"
}

remote_state {
  backend = "gcs"
  config = {
    bucket         = "${local.env}-for-example-state-bucket"
    prefix         = "terraform/state"
  }
}

inputs = {
  file_path = local.file_path
  env       = local.env
}