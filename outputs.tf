output "vm_name" {
  value = var.cloud_provider == "proxmox" ? proxmox_virtual_environment_vm.vm.name : null
}


output "vm_id" {
  value = var.cloud_provider == "proxmox" ? proxmox_virtual_environment_vm.vm.vm_id : null
}

