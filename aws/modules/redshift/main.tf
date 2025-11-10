# Redshift Cluster Module

variable "cluster_identifier" {
  description = "Unique identifier for the cluster"
  type        = string
}

variable "node_type" {
  description = "The node type to be provisioned"
  type        = string
  default     = "dc2.large"
}

variable "number_of_nodes" {
  description = "The number of compute nodes in the cluster"
  type        = number
  default     = 1
}

variable "database_name" {
  description = "The name of the first database to be created"
  type        = string
  default     = "dev"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "master_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the cluster"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "The name of the cluster subnet group"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

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

