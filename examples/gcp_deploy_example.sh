#!/bin/bash

# Example script to deploy GCP data platform infrastructure

set -e

echo "=========================================="
echo "GCP Data Platform Deployment Example"
echo "=========================================="
echo ""

ENVIRONMENT=${1:-dev}
REGION=${2:-us-central1}
PROJECT_ID=${3:-your-project-id}

echo "Deploying to environment: $ENVIRONMENT"
echo "Region: $REGION"
echo "Project: $PROJECT_ID"
echo ""

cd "gcp/environments/$ENVIRONMENT"

# Set GCP project
gcloud config set project $PROJECT_ID

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
terraform plan -var="project_id=$PROJECT_ID" -out=tfplan
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

