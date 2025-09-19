output "vm_info" {
  description = "Complete VM information"
  value = {
    id               = module.proxmox_vm.vm_id
    name             = module.proxmox_vm.vm_name
    ipv4_addresses   = module.proxmox_vm.vm_ipv4_addresses
    ipv6_addresses   = module.proxmox_vm.vm_ipv6_addresses
  }
}

output "vm_id" {
  description = "VM ID"
  value       = module.proxmox_vm.vm_id
}

output "vm_name" {
  description = "VM name"
  value       = module.proxmox_vm.vm_name
}

output "vm_ipv4_addresses" {
  description = "VM IPv4 addresses"
  value       = module.proxmox_vm.vm_ipv4_addresses
}

output "cloud_config_file_id" {
  description = "Cloud config file ID"
  value       = module.cloud_init.cloud_config_file_id
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh ${var.vm_username}@<vm-ip>"
}

output "next_steps" {
  description = "Next steps after deployment"
  value = [
    "1. Wait for VM to complete cloud-init setup (2-5 minutes)",
    "2. Check Tailscale status: tailscale status",
    "3. Verify K3s node joined: kubectl get nodes",
    "4. SSH to VM: ssh ${var.vm_username}@<tailscale-ip>"
  ]
}
