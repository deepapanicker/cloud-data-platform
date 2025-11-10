# Shared Variables
# Common variables used across AWS and GCP

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "data-platform"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "data-platform"
    ManagedBy   = "terraform"
  }
}

