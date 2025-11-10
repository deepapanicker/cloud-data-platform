# AWS Glue Job Module

variable "job_name" {
  description = "Name of the Glue job"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for Glue job"
  type        = string
}

variable "script_location" {
  description = "S3 path to the Glue script"
  type        = string
}

variable "python_version" {
  description = "Python version (2 or 3)"
  type        = string
  default     = "3"
}

variable "glue_version" {
  description = "Glue version"
  type        = string
  default     = "3.0"
}

variable "max_capacity" {
  description = "Maximum number of AWS Glue data processing units"
  type        = number
  default     = 2
}

variable "timeout" {
  description = "Job timeout in minutes"
  type        = number
  default     = 2880
}

variable "default_arguments" {
  description = "Default arguments for the job"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

resource "aws_glue_job" "main" {
  name     = var.job_name
  role_arn = var.role_arn

  command {
    script_location = var.script_location
    python_version  = var.python_version
  }

  glue_version    = var.glue_version
  max_capacity    = var.max_capacity
  timeout         = var.timeout
  default_arguments = var.default_arguments

  tags = var.tags
}

output "job_name" {
  description = "Name of the Glue job"
  value       = aws_glue_job.main.name
}

output "job_arn" {
  description = "ARN of the Glue job"
  value       = aws_glue_job.main.arn
}

