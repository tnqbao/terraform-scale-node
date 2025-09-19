variable "vm_name" {
  description = "Name of the virtual machine"
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
  default     = 2
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 32
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
}

variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}

variable "cloud_config_file_id" {
  description = "Cloud config file ID"
  type        = string
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = []
}
