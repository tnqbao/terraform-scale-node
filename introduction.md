# Terraform Proxmox K3s Node Automation / Tự động hóa Node K3s với Terraform Proxmox

## Overview / Tổng quan

**English:**
This project automates the creation and configuration of Proxmox virtual machines that automatically join a K3s Kubernetes cluster. It uses Terraform Infrastructure as Code (IaC) to provision VMs with cloud-init configuration, automatically installing Tailscale VPN and joining the K3s cluster as worker nodes.

**Tiếng Việt:**
Dự án này tự động hóa việc tạo và cấu hình máy ảo Proxmox để tự động tham gia vào K3s Kubernetes cluster. Sử dụng Terraform Infrastructure as Code (IaC) để cấp phát VM với cấu hình cloud-init, tự động cài đặt Tailscale VPN và tham gia K3s cluster như worker nodes.

## Features / Tính năng

### Automated Infrastructure / Hạ tầng tự động
- **English:** Fully automated VM provisioning on Proxmox VE
- **Tiếng Việt:** Cấp phát VM hoàn toàn tự đ��ng trên Proxmox VE

### Network Configuration / Cấu hình mạng
- **English:** Automatic Tailscale VPN installation and connection
- **Tiếng Việt:** Tự động cài đặt và kết nối Tailscale VPN

### Kubernetes Integration / Tích hợp Kubernetes
- **English:** Automatic K3s worker node installation and cluster joining
- **Tiếng Việt:** Tự động cài đặt K3s worker node và tham gia cluster

### Security / Bảo mật
- **English:** SSH key-based authentication with sudo privileges
- **Tiếng Việt:** Xác thực bằng SSH key với quyền sudo

### Localization / Bản địa hóa
- **English:** Pre-configured with Vietnamese timezone and UTF-8 locale
- **Tiếng Việt:** Cấu hình sẵn múi giờ Việt Nam và locale UTF-8

## Architecture / Kiến trúc

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Terraform     │───▶│   Proxmox VE    │───▶│   K3s Cluster   │
│   (Your PC)     │    │   (VM Host)     │    │   (Master)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         └─────────────▶│   New VM Node   │◀─────────────┘
                        │   + Tailscale   │
                        │   + K3s Agent   │
                        └─────────────────┘
```

## Prerequisites / Yêu cầu

### Infrastructure / Hạ tầng
- **English:** 
  - Proxmox VE server with API access
  - VM template with cloud-init support (Debian 12 recommended)
  - Network connectivity between Proxmox and K3s master
- **Tiếng Việt:**
  - Máy chủ Proxmox VE có quyền truy cập API
  - Template VM hỗ trợ cloud-init (khuyến nghị Debian 12)
  - Kết nối mạng giữa Proxmox và K3s master

### Credentials / Thông tin xác thực
- **English:**
  - Proxmox API token or username/password
  - SSH key pair for VM access
  - Tailscale authentication key
  - K3s cluster join token
- **Tiếng Việt:**
  - API token Proxmox hoặc username/password
  - Cặp SSH key để truy cập VM
  - Key xác thực Tailscale
  - Token tham gia K3s cluster

### Tools / Công cụ
- **English:**
  - Terraform >= 1.0
  - Git (for version control)
  - Text editor (VS Code, Vim, etc.)
- **Tiếng Việt:**
  - Terraform >= 1.0
  - Git (để quản lý phiên bản)
  - Trình soạn thảo văn bản (VS Code, Vim, v.v.)

## Quick Start / Bắt đầu nhanh

### 1. Clone Repository / Sao chép kho lưu trữ
```bash
git clone <repository-url>
cd terraform-scale-node
```

### 2. Configure Environment / Cấu hình môi trường
```bash
# Copy and edit the environment file
# Sao chép và chỉnh sửa file môi trường
cp .env.example .env
nano .env
```

### 3. Load Environment / Tải môi trường
```bash
source .env
```

### 4. Deploy / Triển khai
```bash
terraform init
terraform plan
terraform apply
```

## Project Structure / Cấu trúc dự án

```
terraform-scale-node/
├── .env                 # Environment variables / Biến môi trường
├── main.tf              # Main Terraform configuration / Cấu hình Terraform chính
├── variables.tf         # Variable definitions / Định nghĩa biến
├── outputs.tf           # Output definitions / Định nghĩa đầu ra
├── versions.tf          # Provider versions / Phiên bản provider
├── terraforms.tfvars    # Variable values / Giá trị biến
├── terraform.sh         # Automation script / Script tự động
├── introduction.md      # This file / File này
└── documentation.md     # Detailed documentation / Tài liệu chi tiết
```

## Use Cases / Trường hợp sử dụng

### Development Teams / Nhóm phát triển
- **English:** Quickly spin up development K3s nodes for testing
- **Tiếng Việt:** Nhanh chóng tạo K3s nodes phát triển để thử nghiệm

### CI/CD Pipelines / Quy trình CI/CD
- **English:** Automated testing environments with ephemeral nodes
- **Tiếng Việt:** Môi trường thử nghiệm tự động với nodes tạm thời

### Scaling Operations / Vận hành mở rộng
- **English:** Dynamic cluster scaling based on workload demands
- **Tiếng Việt:** Mở rộng cluster động dựa trên nhu cầu workload

### Homelab / Phòng lab tại nhà
- **English:** Personal Kubernetes learning and experimentation
- **Tiếng Việt:** Học tập và thử nghiệm Kubernetes cá nhân

## Benefits / Lợi ích

### Speed / Tốc độ
- **English:** VM ready in 2-3 minutes vs 30+ minutes manual setup
- **Tiếng Việt:** VM sẵn sàng trong 2-3 phút thay vì 30+ phút thiết lập thủ công

### Consistency / Nhất quán
- **English:** Identical configuration across all nodes
- **Tiếng Việt:** Cấu hình giống hệt nhau trên tất cả nodes

### 🔄 Repeatability / Tái lặp
- **English:** Reproducible infrastructure with version control
- **Tiếng Việt:** Hạ tầng có thể tái tạo với kiểm soát phiên bản

### 💰 Cost Effective / Hiệu quả chi phí
- **English:** Efficient resource utilization and automated lifecycle
- **Tiếng Việt:** Sử dụng tài nguyên hiệu quả và vòng đời tự động

## 🔗 Related Technologies / Công nghệ liên quan

- **Proxmox VE**: Virtualization platform / Nền tảng ảo hóa
- **Terraform**: Infrastructure as Code / Hạ tầng như Code
- **K3s**: Lightweight Kubernetes / Kubernetes nhẹ
- **Tailscale**: Zero-config VPN / VPN không cấu hình
- **Cloud-init**: VM initialization / Khởi tạo VM
- **Debian**: Linux distribution / Bản phân phối Linux

---

📖 **Next Step / Bước tiếp theo:** Read the detailed [documentation.md](./documentation.md) for complete setup and configuration instructions.

📖 **Bước tiếp theo:** Đọc [documentation.md](./documentation.md) chi tiết để có hướng dẫn thiết lập và cấu hình đầy đủ.
