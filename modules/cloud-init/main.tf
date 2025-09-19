resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.snippets_datastore
  node_name    = var.target_node

  source_raw {
    data = templatefile("${path.module}/cloud-init.tftpl", {
      hostname           = var.hostname
      vm_password        = var.vm_password
      vm_username        = var.vm_username
      tailscale_auth_key = var.tailscale_auth_key
      k3s_url           = var.k3s_url
      k3s_token         = var.k3s_token
      timezone          = var.timezone
      locale            = var.locale
      packages          = var.packages
      ssh_authorized_keys = var.ssh_authorized_keys
    })

    file_name = "${var.hostname}-cloud-config.yaml"
  }
}
