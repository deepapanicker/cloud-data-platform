# Cloud Data Platform

Infrastructure as Code (IaC) setup for building scalable cloud data platforms on AWS and GCP. Includes Terraform configurations for data warehouses, ETL pipelines, and monitoring infrastructure.

## 🏗️ Features

- **Multi-Cloud Support**: AWS and GCP infrastructure configurations
- **Terraform IaC**: Complete infrastructure defined as code
- **Data Warehouse Setup**: Redshift, BigQuery, and Snowflake configurations
- **ETL Infrastructure**: Glue, Dataflow, and Airflow setups
- **Storage Solutions**: S3, Cloud Storage, and data lake configurations
- **Monitoring & Alerting**: CloudWatch, Stackdriver, and Grafana setups
- **Security**: IAM roles, VPC configurations, and encryption
- **CI/CD Ready**: GitHub Actions workflows for automated deployments

## 📋 Prerequisites

- Terraform 1.0+
- AWS CLI configured (for AWS deployments)
- Google Cloud SDK (for GCP deployments)
- Appropriate cloud credentials and permissions

## 🛠️ Installation

### 1. Clone the repository

```bash
git clone https://github.com/deepapanicker/cloud-data-platform.git
cd cloud-data-platform
```

### 2. Install Terraform

```bash
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### 3. Configure AWS (for AWS deployments)

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and region
```

### 4. Configure GCP (for GCP deployments)

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

## 📁 Project Structure

```
cloud-data-platform/
├── aws/
│   ├── modules/
│   │   ├── redshift/          # Redshift cluster module
│   │   ├── s3/                # S3 buckets module
│   │   ├── glue/              # Glue jobs module
│   │   ├── lambda/            # Lambda functions module
│   │   └── monitoring/        # CloudWatch setup
│   ├── environments/
│   │   ├── dev/               # Development environment
│   │   ├── staging/           # Staging environment
│   │   └── prod/              # Production environment
│   └── main.tf                # Main AWS configuration
├── gcp/
│   ├── modules/
│   │   ├── bigquery/          # BigQuery datasets
│   │   ├── dataflow/          # Dataflow jobs
│   │   ├── storage/           # Cloud Storage buckets
│   │   └── monitoring/        # Stackdriver setup
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   └── main.tf
├── shared/
│   ├── variables.tf           # Shared variables
│   └── outputs.tf             # Shared outputs
└── README.md
```

## 🚀 Quick Start

### AWS Deployment

```bash
cd aws/environments/dev

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

### GCP Deployment

```bash
cd gcp/environments/dev

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

## 📊 Infrastructure Components

### AWS Components

#### Redshift Data Warehouse

```hcl
module "redshift" {
  source = "../../modules/redshift"
  
  cluster_identifier = "data-warehouse"
  node_type          = "dc2.large"
  number_of_nodes     = 2
  database_name      = "analytics"
  master_username    = "admin"
  master_password    = var.redshift_password
  
  vpc_security_group_ids = [aws_security_group.redshift.id]
  subnet_group_name      = aws_redshift_subnet_group.main.name
}
```

#### S3 Data Lake

```hcl
module "data_lake" {
  source = "../../modules/s3"
  
  bucket_name = "company-data-lake"
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
}
```

### GCP Components

#### BigQuery Dataset

```hcl
module "bigquery" {
  source = "../../modules/bigquery"
  
  dataset_id = "analytics"
  location   = "US"
  
  tables = [
    {
      table_id = "customers"
      schema = file("schemas/customers.json")
    },
    {
      table_id = "orders"
      schema = file("schemas/orders.json")
    }
  ]
}
```

#### Cloud Storage Bucket

```hcl
module "storage" {
  source = "../../modules/storage"
  
  bucket_name = "company-data-lake"
  location    = "US"
  
  lifecycle_rules = [
    {
      action = {
        type = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age = 90
      }
    }
  ]
}
```

## 🔧 Configuration

### Environment Variables

Create `terraform.tfvars`:

```hcl
# AWS Configuration
aws_region = "us-east-1"
environment = "dev"

# Redshift Configuration
redshift_node_type = "dc2.large"
redshift_node_count = 2

# S3 Configuration
s3_bucket_name = "company-data-lake-dev"

# Tags
tags = {
  Environment = "dev"
  Project     = "data-platform"
  ManagedBy   = "terraform"
}
```

## 🔒 Security

### IAM Roles

```hcl
resource "aws_iam_role" "glue_role" {
  name = "glue-etl-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })
}
```

### VPC Configuration

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "data-platform-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = false
}
```

## 📈 Monitoring

### CloudWatch Setup

```hcl
resource "aws_cloudwatch_metric_alarm" "redshift_cpu" {
  alarm_name          = "redshift-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/Redshift"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alert when Redshift CPU exceeds 80%"
}
```

## 🧪 Testing

```bash
# Validate Terraform configuration
terraform validate

# Format Terraform files
terraform fmt

# Check for security issues
terraform plan | grep -i security
```

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy Infrastructure

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: hashicorp/setup-terraform@v1
      
      - name: Terraform Init
        run: terraform init
      
      - name: Terraform Plan
        run: terraform plan
      
      - name: Terraform Apply
        run: terraform apply -auto-approve
```

## 📝 Best Practices

1. **Use Modules**: Reusable modules for common infrastructure patterns
2. **Environment Separation**: Separate configurations for dev/staging/prod
3. **State Management**: Use remote state backends (S3, GCS)
4. **Variable Management**: Use `.tfvars` files for environment-specific values
5. **Tagging**: Consistent tagging strategy for resource management
6. **Security**: Least privilege IAM roles and policies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

MIT License - see LICENSE file for details

## 👤 Author

**Deepa Govinda Panicker**

- GitHub: [@deepapanicker](https://github.com/deepapanicker)
- Portfolio: [deepapanicker.com](https://deepapanicker.com)

