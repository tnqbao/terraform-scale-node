#!/bin/bash

# Script tự động chạy Terraform với biến môi trường từ .env
# Usage: ./terraform.sh [init|plan|apply|destroy]

set -e  # Exit on any error

echo "Terraform Automation Script for Proxmox"
echo "=========================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo "File .env không tồn tại!"
    echo "Vui lòng tạo file .env dựa trên hướng dẫn"
    exit 1
fi

# Load environment variables from .env file
echo "Loading environment variables from .env..."
set -a  # Automatically export all variables
source .env
set +a

# Export variables for Terraform
export TF_VAR_vm_name=$VM_NAME
export TF_VAR_target_node=$TARGET_NODE
export TF_VAR_template_id=$TEMPLATE_ID
export TF_VAR_vm_memory=$VM_MEMORY
export TF_VAR_vm_cores=$VM_CORES
export TF_VAR_vm_disk_size=$VM_DISK_SIZE
export TF_VAR_tailscale_auth_key=$TAILSCALE_AUTH_KEY
export TF_VAR_k3s_url=$K3S_URL
export TF_VAR_k3s_token=$K3S_TOKEN

# Proxmox provider variables
export PROXMOX_VE_ENDPOINT=$PM_API_URL
export PROXMOX_VE_USERNAME=$PM_USER
export PROXMOX_VE_PASSWORD=$PM_PASSWORD
export PROXMOX_VE_INSECURE=$PM_TLS_INSECURE

echo "Environment variables loaded successfully"

# Function to check required variables
check_required_vars() {
    local required_vars=("VM_NAME" "TARGET_NODE" "TEMPLATE_ID" "PM_API_URL" "PM_USER" "PM_PASSWORD")

    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            echo "Required variable $var is not set in .env"
            exit 1
        fi
    done
    echo "All required variables are set"
}

# Check required variables
check_required_vars

# Run Terraform commands based on parameter
case "$1" in
    "init")
        echo "Initializing Terraform..."
        terraform init
        ;;
    "plan")
        echo "Planning Terraform deployment..."
        terraform plan -var-file="terraform.tfvars"
        ;;
    "apply")
        echo "Applying Terraform configuration..."
        echo "VM Name: $VM_NAME"
        echo "Target Node: $TARGET_NODE"
        echo "Template ID: $TEMPLATE_ID"
        echo ""
        read -p "Continue with deployment? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            terraform apply -var-file="terraform.tfvars" -auto-approve
            echo "VM deployment completed!"
            echo "Check Proxmox console for VM status"
        else
            echo "Deployment cancelled"
        fi
        ;;
    "destroy")
        echo "Destroying Terraform infrastructure..."
        echo "This will DELETE the VM: $VM_NAME"
        read -p "Are you sure? (type 'yes' to confirm): " -r
        if [[ $REPLY == "yes" ]]; then
            terraform destroy -var-file="terraform.tfvars" -auto-approve
            echo "Infrastructure destroyed"
        else
            echo "Destruction cancelled"
        fi
        ;;
    "auto")
        echo "Full automatic deployment..."
        terraform init
        terraform plan -var-file="terraform.tfvars"
        terraform apply -var-file="terraform.tfvars" -auto-approve
        echo "🎉 Automatic deployment completed!"
        ;;
    *)
        echo "Usage: ./terraform.sh [init|plan|apply|destroy|auto]"
        echo ""
        echo "Commands:"
        echo "  init     - Initialize Terraform providers"
        echo "  plan     - Show deployment plan"
        echo "  apply    - Deploy VM (with confirmation)"
        echo "  destroy  - Delete VM (with confirmation)"
        echo "  auto     - Full automatic deployment (init + plan + apply)"
        echo ""
        echo "Example: ./terraform.sh auto"
        exit 1
        ;;
esac
