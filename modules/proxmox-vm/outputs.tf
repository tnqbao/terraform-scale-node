output "vm_id" {
  description = "VM ID"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "vm_name" {
  description = "VM name"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ipv4_addresses" {
  description = "VM IPv4 addresses"
  value       = try(proxmox_virtual_environment_vm.vm.ipv4_addresses[1], [])
}

output "vm_ipv6_addresses" {
  description = "VM IPv6 addresses"
  value       = try(proxmox_virtual_environment_vm.vm.ipv6_addresses[1], [])
}
