resource "proxmox_virtual_environment_vm" "vm" {
  # count     = 1
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
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_account {
      username = var.vm_username
      password = var.vm_password
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "snippets"
  node_name    = var.target_node

  source_raw {
    data = <<EOF
#cloud-config
hostname: ${var.vm_name}
locale: en_US.UTF-8
timezone: Asia/Ho_Chi_Minh

users:
  - name: tnqbao
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    plain_text_passwd: ${var.vm_password}
    lock_passwd: false

package_update: true
package_upgrade: true
packages:
  - curl
  - wget
  - sudo
  - tailscale

runcmd:
  - |
    # Set hostname
    echo "${var.vm_name}" > /etc/hostname
    sed -i "s/^127.0.1.1.*/127.0.1.1 ${var.vm_name}/" /etc/hosts
    hostname -F /etc/hostname

    # Install Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh
    systemctl enable --now tailscaled

    # Connect to Tailscale and wait for IP assignment
    tailscale up --authkey=${var.tailscale_auth_key} --accept-routes
    echo "Waiting for Tailscale IP..."
    until NODE_IP=$(tailscale ip -4); do
      sleep 2
    done
    echo "Tailscale IP: $NODE_IP"

    # Install K3S using the Tailscale IP
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="\
      --node-ip $NODE_IP \
      --flannel-iface tailscale0 \
      --kubelet-arg cloud-provider=external \
      --kube-proxy-arg metrics-bind-address=0.0.0.0 \
    " K3S_URL="${var.k3s_url}" K3S_TOKEN="${var.k3s_token}" sh -

    # Reboot the VM
    reboot
EOF
    file_name = "${var.vm_name}-cloud-config.yaml"
  }
}

