terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.40.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://100.122.172.73:8006/api2/json"
  api_token = "terraform@pve!mytoken=a5880bcc-17aa-407e-9725-2e460fa09ae8"
  insecure  = true
}