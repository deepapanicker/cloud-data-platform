# Redshift Module Variables

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

