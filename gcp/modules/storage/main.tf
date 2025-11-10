# Cloud Storage Bucket Module

variable "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  type        = string
}

variable "location" {
  description = "Bucket location"
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "Default storage class"
  type        = string
  default     = "STANDARD"
}

variable "versioning" {
  description = "Enable versioning"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age = optional(number)
      created_before = optional(string)
      with_state = optional(string)
    })
  }))
  default = []
}

variable "labels" {
  description = "Labels to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "Service account email for bucket access"
  type        = string
  default     = ""
}

resource "google_storage_bucket" "main" {
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class

  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lifecycle_rule.value.action.storage_class
      }
      condition {
        age            = lifecycle_rule.value.condition.age
        created_before = lifecycle_rule.value.condition.created_before
        with_state     = lifecycle_rule.value.condition.with_state
      }
    }
  }

  labels = var.labels
}

resource "google_storage_bucket_iam_binding" "main" {
  count = var.service_account_email != "" ? 1 : 0
  
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectViewer"
  
  members = [
    "serviceAccount:${var.service_account_email}",
  ]
}

output "bucket_name" {
  description = "Name of the bucket"
  value       = google_storage_bucket.main.name
}

output "bucket_url" {
  description = "URL of the bucket"
  value       = google_storage_bucket.main.url
}

