# Production Environment Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "redshift_node_type" {
  description = "Redshift node type"
  type        = string
  default     = "dc2.xlarge"  # Larger nodes for production
}

variable "redshift_node_count" {
  description = "Number of Redshift nodes"
  type        = number
  default     = 3  # More nodes for production
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "analytics_prod"
}

variable "redshift_master_username" {
  description = "Redshift master username"
  type        = string
  default     = "admin"
}

variable "redshift_master_password" {
  description = "Redshift master password"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "S3 bucket name for data lake"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "data-platform"
    ManagedBy   = "terraform"
  }
}

