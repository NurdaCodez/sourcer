terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.52.0"
    }
  }
}


provider "google" {
  # Configuration options
  region  = var.region
  project = var.project_id
}