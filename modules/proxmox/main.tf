terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.40.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  node_name   = var.target_node

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
    datastore_id = "local-lvm"
    file_id      = "local:iso/debian-12-generic-amd64.qcow2"
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_account {
      username = "tnqbao"
      keys     = [file("~/.ssh/id_rsa.pub")]
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  source_raw {
    data = <<EOF
#cloud-config
locale: en_US.UTF-8
timezone: Asia/Ho_Chi_Minh

users:
  - name: tnqbao
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ${trimspace(file("~/.ssh/id_rsa.pub"))}

package_update: true
package_upgrade: true
packages:
  - curl
  - wget
  - sudo

runcmd:
  - curl -fsSL https://tailscale.com/install.sh | sh
  - tailscale up --authkey=${var.tailscale_auth_key} --accept-routes
  - curl -sfL https://get.k3s.io | K3S_URL="${var.k3s_url}" K3S_TOKEN="${var.k3s_token}" sh -
EOF
    file_name = "${var.vm_name}-cloud-config.yaml"
  }
}
