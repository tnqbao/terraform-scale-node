#!/bin/bash

# Terraform Automation Script
# Usage: ./terraform.sh [plan|apply|destroy|init] [environment]

set -e

COMMAND=${1:-plan}
ENVIRONMENT=${2:-}
ROOT_DIR=$(dirname "$0")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."

    # Check if terraform is installed
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install Terraform first."
        exit 1
    fi

    # Check terraform version
    TF_VERSION=$(terraform version -json | jq -r '.terraform_version')
    print_info "Terraform version: $TF_VERSION"

    # Check if .env file exists and source it
    if [ -f "$ROOT_DIR/.env" ]; then
        print_info "Loading environment variables from .env file..."
        source "$ROOT_DIR/.env"
    else
        print_warning ".env file not found. Make sure to set environment variables manually."
    fi

    # Check if terraform.tfvars exists
    if [ ! -f "$ROOT_DIR/terraform.tfvars" ] && [ -z "$ENVIRONMENT" ]; then
        print_warning "terraform.tfvars not found. Please create it from terraform.tfvars.example"
    fi
}

# Function to validate configuration
validate_config() {
    print_info "Validating Terraform configuration..."

    if ! terraform validate; then
        print_error "Terraform configuration validation failed!"
        exit 1
    fi

    print_success "Configuration validation passed!"
}

# Function to run terraform commands
run_terraform() {
    local cmd=$1
    local env_dir=""

    if [ -n "$ENVIRONMENT" ]; then
        env_dir="environments/$ENVIRONMENT"
        if [ ! -d "$ROOT_DIR/$env_dir" ]; then
            print_error "Environment directory '$env_dir' does not exist!"
            exit 1
        fi
        cd "$ROOT_DIR/$env_dir"
        print_info "Running in environment: $ENVIRONMENT"
    else
        cd "$ROOT_DIR"
        print_info "Running in root directory"
    fi

    case $cmd in
        "init")
            print_info "Initializing Terraform..."
            terraform init
            ;;
        "plan")
            print_info "Planning Terraform changes..."
            terraform plan
            ;;
        "apply")
            print_info "Applying Terraform changes..."
            terraform plan -out=tfplan
            echo ""
            print_warning "Review the plan above. Do you want to apply these changes? (yes/no)"
            read -r response
            if [ "$response" = "yes" ]; then
                terraform apply tfplan
                rm -f tfplan
                print_success "Terraform apply completed!"
            else
                print_info "Apply cancelled."
                rm -f tfplan
            fi
            ;;
        "destroy")
            print_warning "This will destroy all resources. Are you sure? (yes/no)"
            read -r response
            if [ "$response" = "yes" ]; then
                terraform destroy
                print_success "Resources destroyed!"
            else
                print_info "Destroy cancelled."
            fi
            ;;
        *)
            print_error "Unknown command: $cmd"
            echo "Usage: $0 [init|plan|apply|destroy] [environment]"
            exit 1
            ;;
    esac
}

# Main execution
main() {
    print_info "Starting Terraform automation script..."
    print_info "Command: $COMMAND"
    if [ -n "$ENVIRONMENT" ]; then
        print_info "Environment: $ENVIRONMENT"
    fi

    check_prerequisites

    if [ "$COMMAND" != "init" ]; then
        validate_config
    fi

    run_terraform "$COMMAND"

    print_success "Script completed successfully!"
}

# Show usage if help is requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Terraform Automation Script"
    echo ""
    echo "Usage: $0 [COMMAND] [ENVIRONMENT]"
    echo ""
    echo "Commands:"
    echo "  init     - Initialize Terraform"
    echo "  plan     - Plan Terraform changes"
    echo "  apply    - Apply Terraform changes"
    echo "  destroy  - Destroy all resources"
    echo ""
    echo "Environments:"
    echo "  dev      - Development environment"
    echo "  prod     - Production environment"
    echo "  (empty)  - Root directory"
    echo ""
    echo "Examples:"
    echo "  $0 plan          # Plan in root directory"
    echo "  $0 apply dev     # Apply in development environment"
    echo "  $0 destroy prod  # Destroy production environment"
    exit 0
fi

# Run main function
main
