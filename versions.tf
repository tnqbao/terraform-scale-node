terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.40.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = var.api_token
  insecure  = true

  ssh {
    agent       = false
    username    = "root"
    # private_key = var.private_key
    password = var.pm_password
  }
}