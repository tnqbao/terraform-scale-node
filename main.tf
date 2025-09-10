module "proxmox_vm" {
  source       = "./modules/proxmox"
  count        = var.cloud_provider == "proxmox" ? 1 : 0

  vm_name      = var.vm_name
  vm_memory    = var.vm_memory
  vm_cores     = var.vm_cores
  vm_disk_size = var.vm_disk_size
  target_node  = var.target_node

  tailscale_auth_key = var.tailscale_auth_key
  k3s_url            = var.k3s_url
  k3s_token          = var.k3s_token
}
