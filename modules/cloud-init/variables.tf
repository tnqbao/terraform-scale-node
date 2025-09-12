variable "target_node" {
  description = "Proxmox node name"
  type        = string
}

variable "snippets_datastore" {
  description = "Datastore for snippets"
  type        = string
  default     = "snippets"
}

variable "hostname" {
  description = "VM hostname"
  type        = string
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
  description = "K3s join token"
  type        = string
  sensitive   = true
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
  default     = ["curl", "wget", "sudo", "tailscale", "htop", "vim"]
}

variable "ssh_authorized_keys" {
  description = "SSH public keys"
  type        = list(string)
  default     = []
}
