# Development Environment Outputs

output "redshift_endpoint" {
  description = "Redshift cluster endpoint"
  value       = module.redshift.cluster_endpoint
}

output "redshift_cluster_id" {
  description = "Redshift cluster ID"
  value       = module.redshift.cluster_id
}

output "s3_bucket_name" {
  description = "S3 data lake bucket name"
  value       = module.data_lake.bucket_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

