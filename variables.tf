variable "cloud_provider" {
  description = "Which cloud provider to use: proxmox | aws | gcp"
  type        = string
}

variable "vm_name" {
  description = "VM name"
  type        = string
  default     = "debian-vm"
}

variable "vm_memory" {
  description = "Memory in MB (for Proxmox/GCP)"
  type        = number
  default     = 2048
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

# Proxmox-specific
variable "pm_api_url" {
  type        = string
  default     = ""
}
variable "pm_user" {
  type        = string
  default     = ""
}
variable "pm_password" {
  type        = string
  sensitive   = true
  default     = ""
}
variable "target_node" {
  type    = string
  default = "pve"
}
variable "iso_file" {
  type    = string
  default = "local:iso/debian-12.5.0-amd64-netinst.iso"
}
variable "vm_disk_size" {
  type    = string
  default = "20G"
}

# # AWS-specific
# variable "aws_region" {
#   type    = string
#   default = "us-east-1"
# }
# variable "ami_id" {
#   type    = string
#   default = "" # Debian AMI ID
# }
# variable "instance_type" {
#   type    = string
#   default = "t2.micro"
# }
#
# # GCP-specific
# variable "gcp_project" {
#   type    = string
#   default = ""
# }
# variable "gcp_region" {
#   type    = string
#   default = "us-central1"
# }
# variable "gcp_zone" {
#   type    = string
#   default = "us-central1-a"
# }
# variable "gcp_image" {
#   type    = string
#   default = "debian-cloud/debian-12"
# }
