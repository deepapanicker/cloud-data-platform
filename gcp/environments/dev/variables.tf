# Development Environment Variables

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
  default     = "analytics_dev"
}

variable "storage_bucket_name" {
  description = "Cloud Storage bucket name"
  type        = string
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
  default     = ""
}

variable "bigquery_tables" {
  description = "List of BigQuery tables to create"
  type = list(object({
    table_id = string
    schema   = string
    description = optional(string)
  }))
  default = []
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "data-platform"
    managed_by  = "terraform"
  }
}

