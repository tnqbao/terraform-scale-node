# Development Environment Configuration
# terraform {
#   backend "local" {
#     path = "terraform-dev.tfstate"
#   }
# }

module "dev_vm" {
  source = "../../"

  # VM Configuration
  vm_name     = var.vm_name
  target_node = var.target_node
  template_id = var.template_id

  # Resource allocation for dev
  vm_cores     = var.vm_cores
  vm_memory    = var.vm_memory
  vm_disk_size = var.vm_disk_size

  # Proxmox settings
  pm_api_url = var.pm_api_url
  api_token  = var.api_token
  pm_password = var.pm_password

  # User configuration
  vm_username = var.vm_username
  vm_password = var.vm_password

  # Cluster configuration
  tailscale_auth_key = var.tailscale_auth_key
  k3s_url           = var.k3s_url
  k3s_token         = var.k3s_token

  # Dev-specific packages
  packages = var.packages

  tags = var.tags
}
