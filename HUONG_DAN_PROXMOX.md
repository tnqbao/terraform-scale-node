# Hướng Dẫn Sử Dụng Terraform với Proxmox

## Tổng Quan Dự Án

Dự án này sử dụng Terraform để tự động tạo và cấu hình các máy ảo trên Proxmox VE, sau đó tự động cài đặt và cấu hình:
- **Sudo permissions** cho user
- **Tailscale** để kết nối VPN
- **K3s** để tham gia Kubernetes cluster

## Cấu Trúc Thư Mục

```
terraforn-scale-node/
├── .env                    # Biến môi trường
├── main.tf                 # Cấu hình chính
├── variables.tf            # Khai báo biến
├── terraform.tfvars        # Giá trị biến
├── terraform.sh           # Script tự động
└── modules/
    └── proxmox/
        ├── main.tf         # Logic tạo VM
        ├── variables.tf    # Biến module
        └── outputs.tf      # Output values
```

## Workflow Hoạt Động

### 1. Chuẩn Bị Môi Trường

**Bước 1: Cấu hình biến môi trường**
- File `.env` chứa tất cả thông tin cấu hình
- Sử dụng `source .env` để load biến vào shell

**Bước 2: Cấu hình Proxmox**
```bash
# Trong file .env
PM_API_URL="https://your-proxmox-ip:8006/api2/json"
PM_USER="root@pam"
PM_PASSWORD="your_password"
```

### 2. Quy Trình Tự Động

```
.env → terraform init → terraform apply → VM tạo thành công
  ↓
Cloud-init chạy → Install sudo → Install Tailscale → Install K3s
```

## Chi Tiết Cấu Hình

### Provider Proxmox (bpg/proxmox)

Dự án sử dụng provider `bpg/proxmox` (không phải `telmate/proxmox`) với các tính năng:

```terraform
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.40.0"
    }
  }
}
```

### Tạo VM với Cloud-init

```terraform
resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  node_name   = var.target_node
  
  clone {
    vm_id = var.template_id  # ID của template Debian
    full  = true
  }
}
```

### Cấu Hình Tự Động (Cloud-init)

VM được cấu hình tự động thông qua cloud-init:

1. **Cài đặt packages cơ bản**:
   ```yaml
   packages:
     - curl
     - wget
     - sudo
   ```

2. **Tạo user với sudo privileges**:
   ```yaml
   users:
     - name: tnqbao
       sudo: ALL=(ALL) NOPASSWD:ALL
       groups: sudo
   ```

3. **Cài đặt Tailscale**:
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   tailscale up --authkey=${var.tailscale_auth_key}
   ```

4. **Cài đặt K3s agent**:
   ```bash
   curl -sfL https://get.k3s.io | K3S_URL="${var.k3s_url}" K3S_TOKEN="${var.k3s_token}" sh -
   ```

## Hướng Dẫn Sử Dụng

### 1. Chuẩn Bị Template

Trước khi chạy Terraform, bạn cần:
- Tạo template Debian với cloud-init trên Proxmox
- Ghi nhớ ID của template (ví dụ: 9999)

### 2. Cấu Hình Biến Môi Trường

Chỉnh sửa file `.env`:

```bash
# Proxmox API
PM_API_URL="https://YOUR_PROXMOX_IP:8006/api2/json"
PM_USER="root@pam"
PM_PASSWORD="your_password"

# VM Configuration
TEMPLATE_ID=9999
VM_NAME=k3s-node-01
TARGET_NODE=node1

# Tailscale Auth Key
TAILSCALE_AUTH_KEY="tskey-auth-xxx"

# K3s Configuration
K3S_URL="https://your-k3s-server:6443"
K3S_TOKEN="your-k3s-token"
```

### 3. Chạy Terraform

```bash
# Load biến môi trường
source .env

# Khởi tạo Terraform
terraform init

# Kiểm tra kế hoạch
terraform plan

# Áp dụng cấu hình
terraform apply
```

### 4. Script Tự Động

Sử dụng script `terraform.sh` để tự động hóa toàn bộ quy trình:

```bash
./terraform.sh
```

## Lưu Ý Quan Trọng

### 1. Bảo Mật
- Không commit file `.env` vào git
- Sử dụng biến môi trường cho thông tin nhạy cảm
- Đánh dấu `sensitive = true` cho các biến nhạy cảm

### 2. Template Requirements
- Template phải có cloud-init đã cài đặt
- Template phải có SSH server đã cấu hình
- Network phải được cấu hình DHCP hoặc static

### 3. Firewall
- Đảm bảo port 22 (SSH) mở
- Port 6443 (K3s) có thể truy cập từ nodes khác
- Tailscale ports (41641/UDP) không bị chặn

## Troubleshooting

### Lỗi Provider
```
Error: Invalid resource type "proxmox_vm_qemu"
```
**Giải pháp**: Sử dụng `proxmox_virtual_environment_vm` thay vì `proxmox_vm_qemu`

### Lỗi Authentication
```
Error: authentication failed
```
**Giải pháp**: 
- Kiểm tra `PM_USER` và `PM_PASSWORD`
- Đảm bảo user có quyền API access
- Kiểm tra `PM_API_URL` đúng format

### VM Không Start
- Kiểm tra template ID có tồn tại
- Đảm bảo đủ resources (RAM, disk space)
- Kiểm tra network bridge configuration

## Kết Quả Mong Đợi

Sau khi chạy thành công:
1. VM mới được tạo trên Proxmox
2. User `tnqbao` có sudo permissions
3. Tailscale connected và accessible
4. K3s agent joined cluster
5. VM sẵn sàng làm worker node

## Tài Liệu Tham Khảo

- [bpg/proxmox Provider Documentation](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [Proxmox VE Cloud-Init Guide](https://pve.proxmox.com/wiki/Cloud-Init_Support)
- [K3s Installation Guide](https://rancher.com/docs/k3s/latest/en/installation/)
- [Tailscale Documentation](https://tailscale.com/kb/)
