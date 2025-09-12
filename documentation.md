# Detailed Documentation / Tài liệu chi tiết

## Table of Contents / Mục lục

1. [Installation & Setup / Cài đặt & Thiết lập](#installation--setup--cài-đặt--thiết-lập)
2. [Configuration / Cấu hình](#configuration--cấu-hình)
3. [Environment Variables / Biến môi trường](#environment-variables--biến-môi-trường)
4. [Deployment Process / Quy trình triển khai](#deployment-process--quy-trình-triển-khai)
5. [Cloud-init Configuration / Cấu hình Cloud-init](#cloud-init-configuration--cấu-hình-cloud-init)
6. [Troubleshooting / Khắc phục sự cố](#troubleshooting--khắc-phục-sự-cố)
7. [Advanced Usage / Sử dụng nâng cao](#advanced-usage--sử-dụng-nâng-cao)

---

## Installation & Setup / Cài đặt & Thiết lập

### Step 1: Install Terraform / Bước 1: Cài đặt Terraform

**English:**
```bash
# Download and install Terraform
# Visit: https://developer.hashicorp.com/terraform/downloads

# Verify installation
terraform version
```

**Tiếng Việt:**
```bash
# Tải và cài đặt Terraform
# Truy cập: https://developer.hashicorp.com/terraform/downloads

# Xác minh cài đặt
terraform version
```

### Step 2: Clone Project / Bước 2: Sao chép dự án

```bash
git clone <your-repository-url>
cd terraform-scale-node
```

### Step 3: Prepare Environment File / Bước 3: Chuẩn bị file môi trường

**English:** Create and configure the `.env` file with your specific values:

**Tiếng Việt:** Tạo và cấu hình file `.env` với các giá trị cụ thể của bạn:

```bash
cp .env.example .env
nano .env
```

---

## Configuration / Cấu hình

### Project Structure Explanation / Giải thích cấu trúc dự án

```
terraform-scale-node/
├── .env                    # Environment variables / Biến môi trường
├── main.tf                 # Main Terraform resources / Tài nguyên Terraform chính
├── variables.tf            # Input variable definitions / Định nghĩa biến đầu v��o
├── outputs.tf              # Output value definitions / Định nghĩa giá trị đầu ra
├── versions.tf             # Provider version constraints / Ràng buộc phiên bản provider
├── terraforms.tfvars       # Variable value assignments / Gán giá trị biến
├── terraform.sh            # Automation script / Script tự động hóa
├── terraform.tfstate       # Current state file / File trạng thái hiện tại
└── terraform.tfstate.backup # State backup / Sao lưu trạng thái
```

### Key Files Description / Mô tả các file chính

#### `main.tf`
**English:** Contains the main Terraform resources for creating Proxmox VMs and cloud-init configuration.

**Tiếng Việt:** Chứa các tài nguyên Terraform chính để tạo VM Proxmox và cấu hình cloud-init.

#### `variables.tf`  
**English:** Defines all input variables with their types, descriptions, and default values.

**Tiếng Vi���t:** Định nghĩa tất cả biến đầu vào với kiểu dữ liệu, mô tả và giá trị mặc định.

#### `.env`
**English:** Contains environment variables that are automatically loaded using `source .env`.

**Tiếng Việt:** Chứa các biến môi trường được tự động tải bằng `source .env`.

---

## Environment Variables / Biến môi trường

### Required Variables / Biến bắt buộc

| Variable | Description (EN) | Mô tả (VI) | Example |
|----------|------------------|------------|---------|
| `TF_VAR_pm_api_url` | Proxmox API endpoint | Điểm cuối API Proxmox | `https://192.168.1.100:8006/api2/json` |
| `TF_VAR_api_token` | Proxmox API token | Token API Proxmox | `user@pam!tokenid=uuid` |
| `TF_VAR_vm_name` | Virtual machine name | Tên máy ảo | `agent-4` |
| `TF_VAR_target_node` | Proxmox node name | Tên node Proxmox | `gauas` |
| `TF_VAR_template_id` | VM template ID | ID template VM | `9100` |

### Network & Services / Mạng & Dịch vụ

| Variable | Description (EN) | Mô tả (VI) | Example |
|----------|------------------|------------|---------|
| `TF_VAR_tailscale_auth_key` | Tailscale authentication key | Key xác thực Tailscale | `tskey-auth-xxx...` |
| `TF_VAR_k3s_url` | K3s master server URL | URL máy chủ K3s master | `https://100.107.2.13:6443` |
| `TF_VAR_k3s_token` | K3s cluster join token | Token tham gia cluster K3s | `K10a815e5a51...` |

### VM Configuration / Cấu hình VM

| Variable | Description (EN) | Mô tả (VI) | Default | Example |
|----------|------------------|------------|---------|---------|
| `TF_VAR_vm_memory` | RAM in MB | RAM tính bằng MB | `2048` | `3072` |
| `TF_VAR_vm_cores` | CPU cores | Số lõi CPU | `2` | `2` |
| `TF_VAR_vm_disk_size` | Disk size | Kích thước đĩa | `20G` | `30Gb` |
| `TF_VAR_vm_user` | VM username | Tên người dùng VM | - | `tnqbao` |
| `TF_VAR_vm_password` | VM password | Mật khẩu VM | - | `your-password` |

### Complete .env Example / Ví dụ .env hoàn chỉnh

```bash
#!/bin/sh
# Proxmox Configuration / Cấu hình Proxmox
export TF_VAR_pm_api_url="https://100.122.172.73:8006/api2/json"
export TF_VAR_api_token="terraform@pve!mytoken=a5880bcc-17aa-407e-9725-2e460fa09ae8"

# VM Configuration / Cấu hình VM
export TF_VAR_vm_name="agent-4"
export TF_VAR_target_node="gauas"
export TF_VAR_template_id="9100"
export TF_VAR_vm_memory=3072
export TF_VAR_vm_cores=2
export TF_VAR_vm_disk_size="30Gb"
export TF_VAR_vm_user="tnqbao"
export TF_VAR_vm_password="Qu_bao1604"

# Services Configuration / Cấu hình dịch vụ
export TF_VAR_tailscale_auth_key="tskey-auth-kXtrA88rjA21CNTRL-u2kVW3nb5XNBSdDgVE5PXNa97BecRoviB"
export TF_VAR_k3s_url="https://100.107.2.13:6443"
export TF_VAR_k3s_token="K10a815e5a51ad30a17197d0a40ba1c18b64a9a53aa92b23a1cab845d217283a745::server:2e3244ea5c39230afbb0ef6c5155441a"
```

---

## Deployment Process / Quy trình triển khai

### Method 1: Manual Deployment / Phương pháp 1: Triển khai thủ công

**English:**
1. Load environment variables
2. Initialize Terraform
3. Plan the deployment
4. Apply the configuration

**Tiếng Việt:**
1. Tải biến môi trường
2. Khởi tạo Terraform
3. Lập kế hoạch triển khai
4. Áp dụng cấu hình

```bash
# Step 1: Load environment / Bước 1: Tải môi trường
source .env

# Step 2: Initialize / Bước 2: Khởi tạo
terraform init

# Step 3: Plan / Bước 3: Lập kế hoạch
terraform plan

# Step 4: Apply / Bước 4: Áp dụng
terraform apply
```

### Method 2: Automated Script / Phương pháp 2: Script tự động

**English:** Use the provided automation script:

**Tiếng Việt:** Sử dụng script tự động được cung cấp:

```bash
chmod +x terraform.sh
./terraform.sh
```

### Deployment Timeline / Thời gian triển khai

```
terraform init       →  ~30 seconds   / ~30 giây
terraform plan       →  ~15 seconds   / ~15 giây  
terraform apply      →  ~60 seconds   / ~60 giây
Cloud-init setup     →  ~120 seconds  / ~120 giây
Tailscale connection →  ~30 seconds   / ~30 giây
K3s agent join       →  ~60 seconds   / ~60 giây
──────────────────────────────────────────────────
Total time           →  ~5-6 minutes  / ~5-6 phút
```

---

## Cloud-init Configuration / Cấu hình Cloud-init

### Automatic Setup Process / Quy trình thiết lập tự động

**English:** The cloud-init configuration automatically performs the following actions:

**Tiếng Việt:** Cấu hình cloud-init tự động thực hiện các hành động sau:

#### 1. System Configuration / Cấu hình hệ thống
```yaml
hostname: agent-4                    # Set hostname / Đặt tên máy chủ
locale: en_US.UTF-8                 # Set locale / Đặt ngôn ngữ
timezone: Asia/Ho_Chi_Minh          # Set timezone / Đặt múi giờ
```

#### 2. User Account Setup / Thiết lập tài khoản người dùng
```yaml
users:
  - name: tnqbao                    # Username / Tên người dùng
    sudo: ALL=(ALL) NOPASSWD:ALL    # Sudo privileges / Quyền sudo
    groups: sudo                    # Add to sudo group / Thêm vào nhóm sudo
    shell: /bin/bash                # Default shell / Shell mặc định
    plain_text_passwd: 100604       # Password / Mật khẩu
    lock_passwd: false              # Keep password active / Giữ mật khẩu hoạt động
```

#### 3. Package Installation / Cài đặt gói
```yaml
package_update: true                # Update package list / Cập nhật danh sách gói
package_upgrade: true               # Upgrade packages / Nâng cấp gói
packages:                          # Install packages / Cài đặt gói
  - curl
  - wget  
  - sudo
  - tailscale
```

#### 4. Service Configuration / Cấu hình dịch vụ
```bash
# Install and configure Tailscale / Cài đặt và cấu hình Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
systemctl enable --now tailscaled
tailscale up --authkey=$TAILSCALE_KEY --accept-routes

# Install and configure K3s agent / Cài đặt và cấu hình K3s agent
export NODE_IP=$(tailscale ip -4)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="..." K3S_URL="..." K3S_TOKEN="..." sh -
```

---

## Troubleshooting / Khắc phục sự cố

### Common Issues / Vấn đề thường gặp

#### 1. Authentication Errors / Lỗi xác thực

**Problem / Vấn đề:**
```
Error: Invalid credentials for Proxmox API
```

**Solution / Giải pháp:**
```bash
# Check API token format / Kiểm tra định dạng API token
echo $TF_VAR_api_token

# Verify API URL / Xác minh URL API
curl -k $TF_VAR_pm_api_url/version
```

#### 2. Template Not Found / Không tìm thấy template

**Problem / Vấn đề:**
```
Error: VM template with ID 9100 not found
```

**Solution / Giải pháp:**
```bash
# List available templates / Liệt kê templates có sẵn
# Check Proxmox web UI: Datacenter > Templates
# Verify template ID in .env file
```

#### 3. Cloud-init Issues / Vấn đề Cloud-init

**Problem / Vấn đề:**
```
VM created but cloud-init failed
```

**Solution / Giải pháp:**
```bash
# SSH into VM and check cloud-init logs
# SSH vào VM và kiểm tra logs cloud-init
ssh tnqbao@<vm-ip>
sudo cloud-init status --long
sudo journalctl -u cloud-init
```

#### 4. Network Connectivity / Kết nối mạng

**Problem / Vấn đề:**
```
Tailscale or K3s connection failed
```

**Solution / Giải pháp:**
```bash
# Check Tailscale status / Kiểm tra trạng thái Tailscale
sudo tailscale status

# Check K3s agent status / Kiểm tra trạng thái K3s agent  
sudo systemctl status k3s-agent

# Verify network connectivity / Xác minh kết nối mạng
ping 100.107.2.13
```

### Debug Commands / Lệnh debug

```bash
# Check Terraform state / Kiểm tra trạng thái Terraform
terraform show

# Validate configuration / Xác thực cấu hình
terraform validate

# Show Terraform plan / Hiển thị kế hoạch Terraform
terraform plan -detailed-exitcode

# Check VM status in Proxmox / Kiểm tra trạng thái VM trong Proxmox
# Access Proxmox web UI and check VM console
```

---

## Advanced Usage / Sử dụng nâng cao

### Multiple VM Deployment / Triển khai nhiều VM

**English:** To deploy multiple VMs, you can use Terraform's `count` or `for_each`:

**Tiếng Việt:** Để triển khai nhiều VM, bạn có thể sử dụng `count` hoặc `for_each` của Terraform:

```hcl
# Create multiple VMs / Tạo nhiều VM
resource "proxmox_virtual_environment_vm" "vm" {
  count = var.vm_count
  name  = "${var.vm_name}-${count.index + 1}"
  
  # ...existing configuration...
}
```

### Custom Cloud-init / Cloud-init tùy chỉnh

**English:** Modify the cloud-init configuration in `main.tf` for custom requirements:

**Tiếng Việt:** Sửa đổi cấu hình cloud-init trong `main.tf` cho các yêu cầu tùy chỉnh:

```yaml
# Add custom packages / Thêm gói tùy chỉnh
packages:
  - curl
  - wget
  - sudo
  - tailscale
  - docker.io        # Add Docker / Thêm Docker
  - nginx            # Add Nginx / Thêm Nginx

# Add custom commands / Thêm lệnh tùy chỉnh  
runcmd:
  - docker --version
  - systemctl enable nginx
```

### Environment-specific Configurations / Cấu hình theo môi trường

**English:** Create different `.env` files for different environments:

**Tiếng Việt:** Tạo các file `.env` khác nhau cho các môi trường khác nhau:

```bash
# Development environment / Môi trường phát triển
.env.dev

# Staging environment / Môi trường staging  
.env.staging

# Production environment / Môi trường production
.env.prod

# Usage / Sử dụng
source .env.dev
terraform workspace select dev
terraform apply
```

### Monitoring & Logging / Giám sát & Ghi log

**English:** Add monitoring tools to cloud-init:

**Tiếng Việt:** Thêm công cụ giám sát vào cloud-init:

```yaml
packages:
  - node-exporter     # Prometheus metrics / Metrics Prometheus
  - telegraf          # InfluxDB agent / Agent InfluxDB

runcmd:
  - systemctl enable node-exporter
  - systemctl start node-exporter
```

---

## Additional Resources / Tài nguyên bổ sung

### Documentation Links / Liên kết tài liệu

- **Terraform Proxmox Provider:** https://registry.terraform.io/providers/bpg/proxmox/latest/docs
- **Proxmox VE Documentation:** https://pve.proxmox.com/wiki/Main_Page
- **K3s Documentation:** https://rancher.com/docs/k3s/latest/en/
- **Tailscale Documentation:** https://tailscale.com/kb/
- **Cloud-init Documentation:** https://cloudinit.readthedocs.io/

### Best Practices / Thực hành tốt nhất

1. **English:** Always backup your Terraform state file
   **Tiếng Việt:** Luôn sao lưu file trạng thái Terraform

2. **English:** Use version control for your Terraform configurations
   **Tiếng Việt:** Sử dụng kiểm soát phiên bản cho cấu hình Terraform

3. **English:** Test configurations in development environment first
   **Tiếng Việt:** Kiểm tra cấu hình trong môi trường phát triển trước

4. **English:** Keep sensitive data in environment variables, not in code
   **Tiếng Việt:** Giữ dữ liệu nhạy cảm trong biến môi trường, không trong code

5. **English:** Regularly update Terraform and provider versions
   **Tiếng Việt:** Thường xuyên cập nhật phiên bản Terraform và provider

---

## Support / Hỗ trợ

**English:** For issues and questions:
- Check the troubleshooting section above
- Review Terraform and Proxmox logs
- Consult official documentation
- Open an issue in the project repository

**Tiếng Việt:** Đối với các vấn đề và câu hỏi:
- Kiểm tra phần khắc phục sự cố ở trên
- Xem lại logs Terraform và Proxmox
- Tham khảo tài liệu chính thức
- Mở issue trong repository dự án

---

**Last Updated / Cập nhật lần cuối:** September 2025
**Version / Phiên bản:** 2.0
**Maintainer / Người duy trì:** tnqbao
