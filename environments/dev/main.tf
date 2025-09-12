# Development Environment Configuration
# terraform {
#   backend "local" {
#     path = "terraform-dev.tfstate"
#   }
# }

module "dev_vm" {
  source = "../../"

  # VM Configuration
  vm_name     = "k3s-dev-node"
  target_node = "pve"
  template_id = "9000"

  # Resource allocation for dev
  vm_cores     = 2
  vm_memory    = 2048
  vm_disk_size = "20G"

  # Proxmox settings
  pm_api_url = var.pm_api_url
  api_token  = var.api_token
  pm_password = var.pm_password

  # User configuration
  vm_username = "devuser"
  vm_password = var.vm_password

  # Cluster configuration
  tailscale_auth_key = var.tailscale_auth_key
  k3s_url           = var.k3s_url
  k3s_token         = var.k3s_token

  # Dev-specific packages
  packages = [
    "curl", "wget", "sudo", "tailscale",
    "htop", "vim", "git", "docker.io",
    "build-essential", "nodejs", "npm"
  ]

  tags = ["terraform", "k3s-node", "development"]
}
