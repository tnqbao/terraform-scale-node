# Cloud provider chọn để chạy (proxmox, aws, gcp)
variable "cloud_provider" {
  description = "Cloud provider to use"
  type        = string
  default     = "proxmox"
}

variable "private_key" {
    description = "SSH private key for Proxmox"
    type        = string
}

variable "pm_password" {
    description = "Proxmox root password"
    type        = string
    sensitive   = true
}
# VM cấu hình cơ bản
variable "vm_name" {
  description = "VM name"
  type        = string
}
variable "vm_memory" {
  description = "RAM (MB)"
  type        = number
  default     = 2048
}
variable "vm_cores" {
  description = "CPU cores"
  type        = number
  default     = 2
}
variable "vm_disk_size" {
  description = "Disk size"
  type        = string
  default     = 20
}
variable "target_node" {
  description = "Proxmox node"
  type        = string
}

variable "template_id" {
  description = "Proxmox template VM ID to clone from"
  type        = string
}

# Proxmox API
variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "api_token" {
  description = "Proxmox API token in the format 'USER@REAL"
  type        = string
}

variable "vm_username" {
  description = "VM user"
  type        = string
}
variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}

# Cloud-init tùy chỉnh
variable "tailscale_auth_key" {
  description = "Tailscale auth key"
  type        = string
  sensitive   = true
}
variable "k3s_url" {
  description = "K3s master URL"
  type        = string
}
variable "k3s_token" {
  description = "K3s join token"
  type        = string
  sensitive   = true
}
