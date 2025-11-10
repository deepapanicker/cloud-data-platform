#!/bin/bash

# Terraform validation script
# Validates all Terraform configurations

set -e

echo "=========================================="
echo "Terraform Configuration Validation"
echo "=========================================="
echo ""

ERRORS=0

# Function to validate Terraform directory
validate_terraform_dir() {
    local dir=$1
    if [ -f "$dir/main.tf" ] || [ -f "$dir/variables.tf" ]; then
        echo "Validating: $dir"
        cd "$dir"
        terraform init -backend=false > /dev/null 2>&1
        if terraform validate > /dev/null 2>&1; then
            echo "  ✅ Valid"
        else
            echo "  ❌ Invalid"
            terraform validate
            ERRORS=$((ERRORS + 1))
        fi
        cd - > /dev/null
        echo ""
    fi
}

# Validate AWS modules
echo "Validating AWS modules..."
for module in aws/modules/*/; do
    validate_terraform_dir "$module"
done

# Validate AWS environments
echo "Validating AWS environments..."
for env in aws/environments/*/; do
    validate_terraform_dir "$env"
done

# Validate GCP modules
echo "Validating GCP modules..."
for module in gcp/modules/*/; do
    validate_terraform_dir "$module"
done

# Validate GCP environments
echo "Validating GCP environments..."
for env in gcp/environments/*/; do
    validate_terraform_dir "$env"
done

# Summary
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ All configurations are valid!"
else
    echo "❌ Found $ERRORS configuration errors"
    exit 1
fi
echo "=========================================="

