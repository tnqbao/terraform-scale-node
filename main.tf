module "cloud_init" {
  source = "./modules/cloud-init"

  target_node        = var.target_node
  hostname           = var.vm_name
  vm_username        = var.vm_username
  vm_password        = var.vm_password
  tailscale_auth_key = var.tailscale_auth_key
  k3s_url           = var.k3s_url
  k3s_token         = var.k3s_token
  timezone          = var.timezone
  locale            = var.locale
  packages          = var.packages
  ssh_authorized_keys = var.ssh_authorized_keys
}

module "proxmox_vm" {
  source = "./modules/proxmox-vm"

  vm_name              = var.vm_name
  target_node          = var.target_node
  template_id          = var.template_id
  vm_cores             = var.vm_cores
  vm_memory            = var.vm_memory
  vm_disk_size         = var.vm_disk_size
  datastore_id         = var.datastore_id
  network_bridge       = var.network_bridge
  vm_username          = var.vm_username
  vm_password          = var.vm_password
  cloud_config_file_id = module.cloud_init.cloud_config_file_id
  tags                 = var.tags
}
