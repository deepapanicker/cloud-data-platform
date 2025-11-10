#!/bin/bash

# Example script to deploy AWS data platform infrastructure

set -e

echo "=========================================="
echo "AWS Data Platform Deployment Example"
echo "=========================================="
echo ""

ENVIRONMENT=${1:-dev}
REGION=${2:-us-east-1}

echo "Deploying to environment: $ENVIRONMENT"
echo "Region: $REGION"
echo ""

cd "aws/environments/$ENVIRONMENT"

# Initialize Terraform
echo "1. Initializing Terraform..."
terraform init
echo ""

# Validate configuration
echo "2. Validating Terraform configuration..."
terraform validate
echo ""

# Plan deployment
echo "3. Planning deployment..."
terraform plan -out=tfplan
echo ""

# Apply (uncomment to actually deploy)
# echo "4. Applying changes..."
# terraform apply tfplan
# echo ""

# Show outputs
echo "4. Terraform outputs:"
terraform output
echo ""

echo "=========================================="
echo "Deployment example completed!"
echo "=========================================="
echo ""
echo "To actually deploy, uncomment the apply step in this script."

