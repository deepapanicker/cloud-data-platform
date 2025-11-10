# Stackdriver Monitoring Module

variable "alert_name" {
  description = "Name of the alert policy"
  type        = string
}

variable "display_name" {
  description = "Display name for the alert"
  type        = string
}

variable "metric_type" {
  description = "Metric type (e.g., compute.googleapis.com/instance/cpu/utilization)"
  type        = string
}

variable "threshold_value" {
  description = "Threshold value for the alert"
  type        = number
}

variable "comparison" {
  description = "Comparison operator (COMPARISON_GT, COMPARISON_LT, etc.)"
  type        = string
  default     = "COMPARISON_GT"
}

variable "duration" {
  description = "Duration in seconds"
  type        = string
  default     = "60s"
}

variable "notification_channels" {
  description = "List of notification channel IDs"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels for the alert policy"
  type        = map(string)
  default     = {}
}

resource "google_monitoring_alert_policy" "main" {
  display_name = var.display_name
  combiner     = "OR"

  conditions {
    display_name = var.alert_name

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"${var.metric_type}\""
      duration        = var.duration
      comparison      = var.comparison
      threshold_value = var.threshold_value

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels

  labels = var.labels
}

output "alert_policy_id" {
  description = "Alert policy ID"
  value       = google_monitoring_alert_policy.main.id
}

output "alert_policy_name" {
  description = "Alert policy name"
  value       = google_monitoring_alert_policy.main.name
}

