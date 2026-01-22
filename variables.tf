variable "proxmox_host" {}
variable "proxmox_user" {}
variable "proxmox_user_ssh" {
  description = "SSH user for Proxmox (usually root)"
  default     = "root"
}
variable "proxmox_password" { sensitive = true }
variable "proxmox_node" {}
variable "template_name" { description = "Template name in Proxmox" }

variable "vm_name" {}
variable "vm_user" { default = "root" }
variable "root_password" { sensitive = true }
variable "tailscale_authkey" { sensitive = true }

variable "vm_memory" { default = 2048 }
variable "vm_cpu" { default = 2 }
variable "vm_count" { default = 1 }
