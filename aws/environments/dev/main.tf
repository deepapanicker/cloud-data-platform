# Development Environment - AWS Data Platform

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    # Configure your S3 backend here
    # bucket = "your-terraform-state-bucket"
    # key    = "aws/dev/terraform.tfstate"
    # region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Configuration
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  
  name = "data-platform-vpc-dev"
  cidr = "10.0.0.0/16"
  
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = false
  
  tags = var.tags
}

# Redshift Subnet Group
resource "aws_redshift_subnet_group" "main" {
  name       = "data-platform-redshift-subnet-group-dev"
  subnet_ids = module.vpc.private_subnets
  
  tags = var.tags
}

# Redshift Security Group
resource "aws_security_group" "redshift" {
  name        = "data-platform-redshift-sg-dev"
  description = "Security group for Redshift cluster"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = var.tags
}

# Redshift Cluster
module "redshift" {
  source = "../../modules/redshift"
  
  cluster_identifier = "data-warehouse-dev"
  node_type          = var.redshift_node_type
  number_of_nodes     = var.redshift_node_count
  database_name      = var.database_name
  master_username    = var.redshift_master_username
  master_password    = var.redshift_master_password
  
  vpc_security_group_ids = [aws_security_group.redshift.id]
  subnet_group_name      = aws_redshift_subnet_group.main.name
  
  tags = var.tags
}

# S3 Data Lake
module "data_lake" {
  source = "../../modules/s3"
  
  bucket_name = var.s3_bucket_name
  versioning  = true
  encryption  = true
  
  lifecycle_rules = [
    {
      id     = "archive"
      status = "Enabled"
      transitions = [
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
    }
  ]
  
  tags = var.tags
}

# CloudWatch Alarms
module "redshift_cpu_alarm" {
  source = "../../modules/monitoring"
  
  alarm_name          = "redshift-high-cpu-dev"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/Redshift"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  alarm_description   = "Alert when Redshift CPU exceeds 80%"
  
  dimensions = {
    ClusterIdentifier = module.redshift.cluster_id
  }
  
  tags = var.tags
}

