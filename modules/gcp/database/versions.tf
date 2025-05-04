terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 6.1, < 7"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.1, < 7"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-sql-db:postgresql/v25.2.2"
  }
  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-sql-db:postgresql/v25.2.2"
  }
}