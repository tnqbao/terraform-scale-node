variable "vm_name" {}
variable "vm_memory" {}
variable "vm_cores" {}
variable "pm_api_url" {}
variable "pm_user" {}
variable "pm_password" {
  sensitive = true
}
variable "target_node" {}
variable "iso_file" {}
variable "vm_disk_size" {}
