# CloudWatch Monitoring Module

variable "alarm_name" {
  description = "Name of the CloudWatch alarm"
  type        = string
}

variable "metric_name" {
  description = "Name of the metric"
  type        = string
}

variable "namespace" {
  description = "Namespace of the metric"
  type        = string
}

variable "statistic" {
  description = "Statistic to apply"
  type        = string
  default     = "Average"
}

variable "period" {
  description = "Period in seconds"
  type        = number
  default     = 300
}

variable "evaluation_periods" {
  description = "Number of evaluation periods"
  type        = number
  default     = 2
}

variable "threshold" {
  description = "Alarm threshold"
  type        = number
}

variable "comparison_operator" {
  description = "Comparison operator"
  type        = string
  default     = "GreaterThanThreshold"
}

variable "alarm_description" {
  description = "Description of the alarm"
  type        = string
  default     = ""
}

variable "dimensions" {
  description = "Dimensions for the metric"
  type        = map(string)
  default     = {}
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

resource "aws_cloudwatch_metric_alarm" "main" {
  alarm_name          = var.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  alarm_description   = var.alarm_description

  dynamic "dimensions" {
    for_each = var.dimensions
    content {
      name  = dimensions.key
      value = dimensions.value
    }
  }

  alarm_actions = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = var.tags
}

output "alarm_arn" {
  description = "ARN of the CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.main.arn
}

