# Terraform Proxmox Cloud-Init Demo

## Tổng quan
Project này sử dụng Terraform để tạo VMs trên Proxmox với cloud-init configuration được tạo tự động.

### Tính năng chính
- ✅ Cloud-init configuration tự động tạo từ template
- ✅ Tự động upload cloud-init lên Proxmox
- ✅ Cấu hình Tailscale và SSH tự động
- ✅ Không cần upload thủ công snippet files

## Yêu cầu

### Phần mềm
- Terraform >= 1.4.0
- PowerShell (có sẵn trên Windows)
- PowerShell Remoting phải được enable trên Proxmox host

### Proxmox
- Template VM đã được tạo (cloud-init enabled)
- Storage `local` phải có snippets enabled

## Cách sử dụng

### 1. Cấu hình variables
Cập nhật file `terraform.tfvars` với thông tin của bạn:

```hcl
proxmox_host     = "your-proxmox-ip"
proxmox_user     = "root@pam"
proxmox_password = "your-password"
proxmox_node     = "pve"

template_name     = "ubuntu-22_04"
vm_name           = "ubuntu-test"  
root_password     = "your-vm-password"
tailscale_authkey = "tskey-auth-xxxxx"

vm_count  = 1
vm_cpu    = 1
vm_memory = 1024
```

### 2. Initialize Terraform

```powershell
terraform init
```

### 3. Kiểm tra plan

```powershell
terraform plan
```

### 4. Apply configuration

```powershell
terraform apply
```

## Cấu trúc Files

```
tf-demo/
├── main.tf                      # Main configuration
├── variables.tf                 # Variable definitions  
├── terraform.tfvars             # Variable values (git ignored)
├── versions.tf                  # Provider versions
├── outputs.tf                   # Outputs
├── cloud-init-user.yml          # Cloud-init template
└── generated-*.yml              # Generated files (auto-created)
```

## Cloud-Init Template

File `cloud-init-user.yml` chứa template cho cloud-init configuration:

- **Root access**: Enable root login với password
- **SSH config**: Enable password authentication
- **Tailscale**: Tự động cài đặt và kết nối với authkey

## Cách hoạt động

1. **Template rendering**: Terraform đọc `cloud-init-user.yml` và thay thế variables
2. **File generation**: Tạo file `generated-cloud-init-user-*.yml` 
3. **Upload**: Sử dụng PowerShell để upload file lên `/var/lib/vz/snippets/` trên Proxmox
4. **VM creation**: Tạo VM với cicustom pointing to uploaded snippet

## Troubleshooting

### PowerShell Remoting Issues

Nếu gặp lỗi PowerShell remoting, có thể cần:

1. Enable WSMan trên Proxmox:
```bash
# Trên Proxmox host
apt-get install -y openssh-server
```

2. Sử dụng alternative method với `pscp` (PuTTY):
   - Download PuTTY suite
   - Thay đổi provisioner trong `main.tf` để sử dụng `pscp`

### VM không nhận được cloud-init

Kiểm tra:
- Template VM có cloud-init package chưa
- Storage `local` có snippets enabled chưa
- File cloud-init-user.yml có được upload đến đúng path chưa

## Lưu ý bảo mật

⚠️ **QUAN TRỌNG**: File `terraform.tfvars` chứa sensitive data:
- Thêm `terraform.tfvars` vào `.gitignore`
- Không commit passwords/authkeys vào git
- Sử dụng environment variables hoặc secret management cho production

## License

MIT
