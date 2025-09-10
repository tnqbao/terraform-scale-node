variable "vm_name" {}
variable "vm_memory" {}
variable "vm_cores" {}
variable "vm_disk_size" {}
variable "target_node" {}
variable "template_id" {}

variable "tailscale_auth_key" {
  sensitive = true
}
variable "k3s_url" {}
variable "k3s_token" {
  sensitive = true
}
