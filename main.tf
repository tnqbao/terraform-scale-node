provider "proxmox" {
  pm_api_url      = "https://${var.proxmox_host}:8006/api2/json"
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

# Generate cloud-init user data file dynamically
resource "local_file" "cloud_init_user" {
  content = templatefile("${path.module}/cloud-init-user.yml", {
    root_password     = var.root_password
    tailscale_authkey = var.tailscale_authkey
  })
  filename = "${path.module}/generated-cloud-init-user-${var.vm_name}.yml"
}

# Upload cloud-init config to Proxmox using SSH
resource "null_resource" "upload_cloud_init" {
  depends_on = [local_file.cloud_init_user]

  triggers = {
    cloud_init_content = local_file.cloud_init_user.content
  }

  provisioner "local-exec" {
    command     = <<-EOT
      $password = ConvertTo-SecureString '${var.proxmox_password}' -AsPlainText -Force
      $credential = New-Object System.Management.Automation.PSCredential ('${var.proxmox_user_ssh}', $password)
      $session = New-PSSession -ComputerName ${var.proxmox_host} -Credential $credential -Authentication Basic
      Copy-Item -Path '${local_file.cloud_init_user.filename}' -Destination '/var/lib/vz/snippets/cloud-init-user.yml' -ToSession $session
      Remove-PSSession $session
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
}

resource "proxmox_vm_qemu" "vm" {
  depends_on = [null_resource.upload_cloud_init]

  count       = var.vm_count
  name        = "${var.vm_name}-${count.index}"
  clone       = var.template_name
  full_clone  = false
  target_node = var.proxmox_node
  os_type     = "cloud-init"

  cores   = var.vm_cpu
  memory  = var.vm_memory
  sockets = 1

  # Network
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Disk
  disks {
    scsi {
      scsi0 {
        disk {
          size    = "20G"
          storage = "local-lvm"
        }
      }
    }
  }

  # Cloud-Init top-level
  ciuser     = var.vm_user
  cipassword = var.root_password
  sshkeys    = ""
  ipconfig0  = "ip=dhcp"

  # Cloud-Init custom script (Tailscale + SSH config)
  cicustom = "user=local:snippets/cloud-init-user.yml"

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
