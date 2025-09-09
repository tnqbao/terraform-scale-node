provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "this" {
  name        = var.vm_name
  target_node = var.target_node

  iso         = var.iso_file
  os_type     = "l26"
  cores       = var.vm_cores
  sockets     = 1
  memory      = var.vm_memory

  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "order=ide2;scsi0"
  agent       = 1
  onboot      = true

  disk {
    size    = var.vm_disk_size
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}
