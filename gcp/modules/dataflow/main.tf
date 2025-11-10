# Cloud Dataflow Job Module

variable "job_name" {
  description = "Name of the Dataflow job"
  type        = string
}

variable "template_path" {
  description = "GCS path to the Dataflow template"
  type        = string
}

variable "temp_location" {
  description = "GCS path for temporary files"
  type        = string
}

variable "parameters" {
  description = "Parameters for the Dataflow job"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Region for the Dataflow job"
  type        = string
  default     = "us-central1"
}

variable "max_workers" {
  description = "Maximum number of workers"
  type        = number
  default     = 10
}

variable "machine_type" {
  description = "Machine type for workers"
  type        = string
  default     = "n1-standard-1"
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
}

variable "labels" {
  description = "Labels for the job"
  type        = map(string)
  default     = {}
}

resource "google_dataflow_job" "main" {
  name              = var.job_name
  template_gcs_path = var.template_path
  temp_gcs_location = var.temp_location
  region            = var.region
  max_workers       = var.max_workers
  machine_type      = var.machine_type
  service_account_email = var.service_account_email

  parameters = var.parameters

  labels = var.labels
}

output "job_id" {
  description = "Dataflow job ID"
  value       = google_dataflow_job.main.id
}

output "job_state" {
  description = "Current state of the job"
  value       = google_dataflow_job.main.state
}

