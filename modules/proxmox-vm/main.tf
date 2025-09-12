resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.target_node

  clone {
    vm_id = var.template_id
    full  = true
  }

  cpu {
    cores = var.vm_cores
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  initialization {
    user_account {
      username = var.vm_username
      password = var.vm_password
    }

    user_data_file_id = var.cloud_config_file_id
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}
