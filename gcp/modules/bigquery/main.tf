# BigQuery Dataset Module

variable "dataset_id" {
  description = "Unique ID for the dataset"
  type        = string
}

variable "location" {
  description = "Geographic location for the dataset"
  type        = string
  default     = "US"
}

variable "description" {
  description = "Dataset description"
  type        = string
  default     = ""
}

variable "tables" {
  description = "List of tables to create"
  type = list(object({
    table_id = string
    schema   = string  # JSON schema file path
    description = optional(string)
  }))
  default = []
}

variable "labels" {
  description = "Labels to apply to the dataset"
  type        = map(string)
  default     = {}
}

resource "google_bigquery_dataset" "main" {
  dataset_id  = var.dataset_id
  location    = var.location
  description = var.description
  labels      = var.labels
}

resource "google_bigquery_table" "tables" {
  for_each = { for table in var.tables : table.table_id => table }

  dataset_id = google_bigquery_dataset.main.dataset_id
  table_id   = each.value.table_id
  description = each.value.description

  schema = file(each.value.schema)
}

output "dataset_id" {
  description = "BigQuery dataset ID"
  value       = google_bigquery_dataset.main.dataset_id
}

output "dataset_location" {
  description = "BigQuery dataset location"
  value       = google_bigquery_dataset.main.location
}

