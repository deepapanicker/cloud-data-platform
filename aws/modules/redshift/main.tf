# Redshift Cluster Module
# Variables are defined in variables.tf

resource "aws_redshift_cluster" "main" {
  cluster_identifier = var.cluster_identifier
  node_type          = var.node_type
  number_of_nodes    = var.number_of_nodes
  database_name       = var.database_name
  master_username     = var.master_username
  master_password     = var.master_password

  vpc_security_group_ids = var.vpc_security_group_ids
  cluster_subnet_group_name = var.subnet_group_name

  skip_final_snapshot = true
  publicly_accessible = false

  tags = var.tags
}

output "cluster_endpoint" {
  description = "The Redshift cluster endpoint"
  value       = aws_redshift_cluster.main.endpoint
}

output "cluster_id" {
  description = "The Redshift cluster identifier"
  value       = aws_redshift_cluster.main.id
}



