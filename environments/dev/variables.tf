# Development Environment Variables

variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "pm_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  description = "Virtual machine name"
  type        = string
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
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
}

variable "vm_username" {
  description = "VM username"
  type        = string
}

variable "vm_password" {
  description = "VM user password"
  type        = string
  sensitive   = true
}

variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type        = string
  sensitive   = true
}

variable "k3s_url" {
  description = "K3s cluster URL"
  type        = string
}

variable "k3s_token" {
  description = "K3s cluster token"
  type        = string
  sensitive   = true
}

variable "packages" {
  description = "Additional packages to install"
  type        = list(string)
  default     = ["curl", "wget", "sudo", "tailscale", "htop", "vim", "git"]
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = ["terraform", "k3s-node"]
}
