output "vm_ids" {
  value = proxmox_vm_qemu.vm.*.vmid
}

output "vm_names" {
  value = proxmox_vm_qemu.vm.*.name
}
