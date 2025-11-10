# Development Environment - GCP Data Platform

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
    # prefix = "gcp/dev"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# BigQuery Dataset
module "bigquery" {
  source = "../../modules/bigquery"
  
  dataset_id  = var.dataset_id
  location    = var.region
  description = "Analytics dataset for development environment"
  
  tables = var.bigquery_tables
  
  labels = var.labels
}

# Cloud Storage Bucket
module "storage" {
  source = "../../modules/storage"
  
  bucket_name = var.storage_bucket_name
  location    = var.region
  versioning  = true
  
  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age = 90
      }
    }
  ]
  
  service_account_email = var.service_account_email
  labels = var.labels
}

# Monitoring Alerts
module "bigquery_slot_alarm" {
  source = "../../modules/monitoring"
  
  alert_name      = "bigquery-high-slot-usage-dev"
  display_name    = "BigQuery High Slot Usage (Dev)"
  metric_type     = "bigquery.googleapis.com/slots/total_available"
  threshold_value = 80
  comparison      = "COMPARISON_GT"
  
  labels = var.labels
}

