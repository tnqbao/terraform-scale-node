# Production Environment Configuration
# terraform {
#   backend "s3" {
#     bucket = "your-terraform-state-bucket"
#     key    = "prod/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

module "prod_vm" {
  source = "../../"

  # VM Configuration
  vm_name     = "k3s-prod-node"
  target_node = "pve"
  template_id = "9000"

  # Resource allocation for production
  vm_cores     = 4
  vm_memory    = 4096
  vm_disk_size = "50G"

  # Proxmox settings
  pm_api_url = var.pm_api_url
  api_token  = var.api_token
  pm_password = var.pm_password

  # User configuration
  vm_username = "produser"
  vm_password = var.vm_password

  # Cluster configuration
  tailscale_auth_key = var.tailscale_auth_key
  k3s_url           = var.k3s_url
  k3s_token         = var.k3s_token

  # Production-focused packages
  packages = [
    "curl", "wget", "sudo", "tailscale",
    "htop", "vim", "git", "fail2ban",
    "ufw", "logrotate", "rsyslog"
  ]

  tags = ["terraform", "k3s-node", "production"]
}
