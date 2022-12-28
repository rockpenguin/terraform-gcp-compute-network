################################################################################
# Provider Config
################################################################################
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.45"
    }
  }
}
