variable "cloud_provider" {
  description = "Cloud provider to use (currently only proxmox supported)"
  type        = string
  default     = "proxmox"

  validation {
    condition     = contains(["proxmox"], var.cloud_provider)
    error_message = "Only 'proxmox' provider is currently supported."
  }
}

variable "pm_api_url" {
  description = "Proxmox API URL (e.g., https://your-proxmox:8006/api2/json)"
  type        = string

  validation {
    condition     = can(regex("^https?://", var.pm_api_url))
    error_message = "API URL must start with http:// or https://"
  }
}

variable "api_token" {
  description = "Proxmox API token in format 'USER@REALM!TOKENID=UUID'"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[^@]+@[^!]+![^=]+=.+$", var.api_token))
    error_message = "API token must be in format 'USER@REALM!TOKENID=UUID'"
  }
}

variable "pm_password" {
  description = "Proxmox root password (alternative to private key)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "private_key" {
  description = "SSH private key for Proxmox connection"
  type        = string
  sensitive   = true
  default     = ""
}

variable "vm_name" {
  description = "Virtual machine name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.vm_name))
    error_message = "VM name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "target_node" {
  description = "Proxmox node to deploy VM on"
  type        = string
}

variable "template_id" {
  description = "Template VM ID to clone from"
  type        = string
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2

  validation {
    condition     = var.vm_cores >= 1 && var.vm_cores <= 32
    error_message = "CPU cores must be between 1 and 32."
  }
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048

  validation {
    condition     = var.vm_memory >= 512 && var.vm_memory <= 65536
    error_message = "Memory must be between 512MB and 64GB."
  }
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 32

  validation {
    condition     = var.vm_disk_size >= 1 && var.vm_disk_size <= 1024
    error_message = "Disk size must be between 1GB and 1024GB."
  }
}

variable "datastore_id" {
  description = "Datastore ID for VM disk"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "vm_username" {
  description = "VM username"
  type        = string
  default     = "tnqbao"
}

variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}

variable "ssh_authorized_keys" {
  description = "List of SSH public keys for user authentication"
  type        = list(string)
  default     = []
}

variable "timezone" {
  description = "System timezone"
  type        = string
  default     = "Asia/Ho_Chi_Minh"
}

variable "locale" {
  description = "System locale"
  type        = string
  default     = "en_US.UTF-8"
}

variable "packages" {
  description = "Additional packages to install"
  type        = list(string)
  default     = ["curl", "wget", "sudo", "tailscale", "htop", "vim", "git"]
}

variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^tskey-", var.tailscale_auth_key))
    error_message = "Tailscale auth key must start with 'tskey-'."
  }
}

variable "k3s_url" {
  description = "K3s cluster URL (e.g., https://master-ip:6443)"
  type        = string

  validation {
    condition     = can(regex("^https://.*:6443$", var.k3s_url))
    error_message = "K3s URL must be in format 'https://ip:6443'."
  }
}

variable "k3s_token" {
  description = "K3s join token"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.k3s_token) > 10
    error_message = "K3s token must be at least 10 characters long."
  }
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = ["terraform", "k3s-node"]
}

variable "snippets_datastore" {
  description = "Datastore for cloud-init snippets"
  type        = string
  default     = "snippets"
}
