# Terraform Scale Node

Dự án Terraform để tạo VM trên Proxmox với cloud-init:
- Locale: en_US.UTF-8
- Timezone: Asia/Ho_Chi_Minh
- User: tnqbao (sudo)
- Tự động cài Tailscale + join bằng Auth Key
- Tự động join K3s cluster (agent)

## Cách chạy

### 1. Xuất biến môi trường

#### Linux/macOS
```bash
export TF_VAR_pm_api_url="https://192.168.1.100:8006/api2/json"
export TF_VAR_pm_user="root@pam"
export TF_VAR_pm_password="yourpassword"

export TF_VAR_vm_name="debian-auto"
export TF_VAR_target_node="pve"
export TF_VAR_vm_memory=4096
export TF_VAR_vm_cores=2
export TF_VAR_vm_disk_size="20G"

export TF_VAR_tailscale_auth_key="tskey-auth-xxxx"
export TF_VAR_k3s_url="https://100.107.2.13:6443"
export TF_VAR_k3s_token="K10a815eXXXXXXXXXXXX"
