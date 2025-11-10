# Staging Environment - GCP Data Platform

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  backend "gcs" {
    # Configure your GCS backend here
    # bucket = "your-terraform-state-bucket"
    # prefix = "gcp/staging"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Similar structure to dev, but with staging-specific configurations

