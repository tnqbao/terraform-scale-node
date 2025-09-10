cloud_provider = "proxmox"

pm_api_url     = "https://100.122.172.73:8006/api2/json"
vm_name        = "my-vm"
target_node    = "node1"
template_id    = 9999  # ID của template Debian cloud-init
vm_memory      = 3072
vm_cores       = 2
vm_disk_size   = "30G"

# Cần được thiết lập từ biến môi trường
tailscale_auth_key = ""  # Sẽ được thiết lập từ .env
k3s_url           = ""   # Sẽ được thiết lập từ .env
k3s_token         = ""   # Sẽ được thiết lập từ .env
