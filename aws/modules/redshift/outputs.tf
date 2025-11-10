# Redshift Module Outputs

output "cluster_endpoint" {
  description = "The Redshift cluster endpoint"
  value       = aws_redshift_cluster.main.endpoint
}

output "cluster_id" {
  description = "The Redshift cluster identifier"
  value       = aws_redshift_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the Redshift cluster"
  value       = aws_redshift_cluster.main.arn
}

