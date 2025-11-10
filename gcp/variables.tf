# Shared GCP Variables

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "labels" {
  description = "Default labels for all resources"
  type        = map(string)
  default = {
    project     = "data-platform"
    managed_by  = "terraform"
  }
}

