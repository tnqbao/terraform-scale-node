output "vm_name" {
  value = var.cloud_provider == "proxmox" ? module.proxmox_vm.vm_name : null
}


output "vm_id" {
  value = var.cloud_provider == "proxmox" ? module.proxmox_vm.vm_id : null
}
