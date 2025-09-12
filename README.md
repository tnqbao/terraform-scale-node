# Terraform Proxmox K3s Node Deployment

## 📋 Tổng quan

Dự án này tự động tạo VM trên Proxmox với cloud-init để join vào K3s cluster thông qua Tailscale VPN.

### Tính năng chính:
- Module hóa code (proxmox-vm, cloud-init)
- Validation cho tất cả variables
- Multi-environment support (dev/prod)
- Template cloud-init linh hoạt
- SSH key authentication
- Automated K3s node setup
- Tailscale VPN integration
- Comprehensive error handling

## Cấu trúc dự án

```
terraforn-scale-node/
├── modules/
│   ├── proxmox-vm/          # VM deployment module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── cloud-init/          # Cloud-init configuration module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── cloud-init.tftpl # Template file
├── environments/
│   ├── dev/                 # Development environment
│   └── prod/                # Production environment
├── main-new.tf             # Improved main configuration
├── variables-new.tf         # Enhanced variables with validation
├── outputs-new.tf           # Comprehensive outputs
├── terraform.tfvars.example # Configuration template
└── terraform-improved.sh   # Automation script
```

## Cách sử dụng

### 1. Setup ban đầu

```bash
# Clone project
git clone <repository-url>
cd terraforn-scale-node

# Copy and edit configuration
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

### 2. Chạy với script tự động

```bash
# Initialize
./terraform-improved.sh init

# Plan changes
./terraform-improved.sh plan

# Apply changes
./terraform-improved.sh apply

# Destroy resources
./terraform-improved.sh destroy
```

### 3. Chạy với environments

```bash
# Deploy to development
./terraform-improved.sh apply dev

# Deploy to production
./terraform-improved.sh apply prod
```

## Configuration

### Required Variables:
- `pm_api_url`: Proxmox API URL
- `api_token`: Proxmox API token
- `vm_name`: VM name
- `target_node`: Proxmox node
- `template_id`: Template VM ID
- `vm_password`: VM password
- `tailscale_auth_key`: Tailscale auth key
- `k3s_url`: K3s cluster URL
- `k3s_token`: K3s join token

### Optional Variables:
- `vm_cores`: CPU cores (default: 2)
- `vm_memory`: Memory MB (default: 2048)
- `vm_disk_size`: Disk size (default: "20G")
- `ssh_authorized_keys`: SSH public keys
- `packages`: Additional packages
- `tags`: VM tags

## Troubleshooting

### Common Issues:

1. **SSH Key Error**: Đặt SSH keys trong `ssh_authorized_keys` thay vì dùng file path
2. **Validation Errors**: Kiểm tra format của variables (API token, K3s URL, etc.)
3. **Template Missing**: Đảm bảo template ID tồn tại trên Proxmox
4. **Network Issues**: Kiểm tra Tailscale auth key và K3s cluster connectivity

## Monitoring

Sau khi deploy, kiểm tra:

```bash
# SSH vào VM
ssh tnqbao@<vm-ip>

# Kiểm tra Tailscale
sudo tailscale status

# Kiểm tra K3s
sudo systemctl status k3s-agent

# Xem logs cloud-init
sudo cat /var/log/cloud-init-output.log
```

## Security Best Practices

1. **SSH Keys**: Sử dụng SSH keys thay vì password
2. **API Tokens**: Sử dụng API tokens có quyền hạn chế
3. **Secrets**: Store sensitive data trong `.env` file
4. **Network**: Sử dụng Tailscale VPN cho bảo mật
5. **Updates**: Định kỳ update template và packages

## Backup và Recovery

```bash
# Backup Terraform state
cp terraform.tfstate terraform.tfstate.backup

# Backup VM
qm backup <vm-id> --storage <storage-name>
```
