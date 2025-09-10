# Workflow Tạo VM K3s Node với Terraform

## Quy Trình Tự Động Hoàn Chỉnh

### Bước 1: Chuẩn Bị
```bash
# 1. Clone repository
git clone <repo-url>
cd terraforn-scale-node

# 2. Cấu hình biến môi trường
cp .env.example .env
nano .env  # Chỉnh sửa các giá trị cần thiết
```

### Bước 2: Workflow Tự Động
```
Load .env → Terraform Init → Terraform Apply → VM Creation
    ↓
Cloud-init Script → Install sudo → Install Tailscale → Install K3s
    ↓
VM Ready as K3s Worker Node
```

## Chi Tiết Từng Bước

### 1. Load Environment Variables
```bash
source .env
export TF_VAR_vm_name=$VM_NAME
export TF_VAR_target_node=$TARGET_NODE
export TF_VAR_template_id=$TEMPLATE_ID
export TF_VAR_vm_memory=$VM_MEMORY
export TF_VAR_vm_cores=$VM_CORES
export TF_VAR_vm_disk_size=$VM_DISK_SIZE
export TF_VAR_tailscale_auth_key=$TAILSCALE_AUTH_KEY
export TF_VAR_k3s_url=$K3S_URL
export TF_VAR_k3s_token=$K3S_TOKEN
```

### 2. Terraform Execution
```bash
# Initialize providers
terraform init

# Plan deployment
terraform plan -var-file="terraform.tfvars"

# Apply configuration
terraform apply -var-file="terraform.tfvars" -auto-approve
```

### 3. VM Post-Creation Process

**Cloud-init tự động thực hiện:**

1. **System Update & Package Installation**
   ```bash
   apt update && apt upgrade -y
   apt install -y curl wget sudo
   ```

2. **User Configuration**
   ```bash
   # User tnqbao đã được tạo với sudo privileges
   # SSH key đã được cấu hình
   ```

3. **Tailscale Installation & Setup**
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   tailscale up --authkey=$TAILSCALE_AUTH_KEY --accept-routes
   ```

4. **K3s Agent Installation**
   ```bash
   curl -sfL https://get.k3s.io | \
     K3S_URL=$K3S_URL \
     K3S_TOKEN=$K3S_TOKEN \
     sh -
   ```

## Kiểm Tra Kết Quả

### 1. Verify VM Creation
```bash
# Check VM status trên Proxmox
# VM should be running with cloud-init completed
```

### 2. Verify SSH Access
```bash
ssh tnqbao@<vm-ip>
sudo whoami  # Should return 'root' without password prompt
```

### 3. Verify Tailscale
```bash
ssh tnqbao@<vm-ip>
sudo tailscale status
```

### 4. Verify K3s
```bash
ssh tnqbao@<vm-ip>
sudo systemctl status k3s-agent
sudo k3s kubectl get nodes  # From K3s server
```

## Troubleshooting Common Issues

### 1. Template không tồn tại
```
Error: template with ID 9999 not found
```
**Solution**: Kiểm tra và cập nhật `TEMPLATE_ID` trong `.env`

### 2. Network connectivity issues
```
Error: VM không thể connect internet
```
**Solution**: 
- Kiểm tra bridge `vmbr0` configuration
- Verify DHCP/Static IP settings
- Check firewall rules

### 3. Cloud-init failed
```
VM created but services not installed
```
**Solution**:
- SSH vào VM và check `/var/log/cloud-init-output.log`
- Verify internet connectivity từ VM
- Check auth keys validity

### 4. K3s join failed
```
K3s agent không join được cluster
```
**Solution**:
- Verify `K3S_URL` accessible từ VM
- Check `K3S_TOKEN` validity
- Ensure port 6443 mở trên server

## Advanced Configuration

### 1. Multiple VMs
```bash
# Tạo nhiều VMs với tên khác nhau
export VM_NAME=k3s-node-01
./terraform.sh

export VM_NAME=k3s-node-02  
./terraform.sh
```

### 2. Custom VM Specs
```bash
# Modify .env for different specifications
VM_MEMORY=4096
VM_CORES=4
VM_DISK_SIZE=50G
```

### 3. Different Proxmox Nodes
```bash
# Deploy to different nodes
TARGET_NODE=node1  # First deployment
TARGET_NODE=node2  # Second deployment
```

## Best Practices

### 1. Security
- Rotate Tailscale auth keys regularly
- Use strong passwords for Proxmox
- Implement proper firewall rules
- Regular VM updates

### 2. Monitoring
- Monitor VM resources usage
- Check K3s cluster health
- Monitor Tailscale connectivity
- Setup logging aggregation

### 3. Backup Strategy
- Backup Proxmox templates
- Export Terraform state
- Document configuration changes
- Regular cluster backups

## Expected Timeline

| Phase | Duration | Description |
|-------|----------|-------------|
| VM Creation | 2-3 minutes | Proxmox clone and start |
| Cloud-init | 3-5 minutes | Package install and config |
| Tailscale Setup | 1-2 minutes | VPN connection |
| K3s Installation | 2-3 minutes | Agent setup and join |
| **Total** | **8-13 minutes** | Ready for workloads |

## Resource Requirements

### Minimum VM Specs
- **RAM**: 2GB (4GB recommended)
- **CPU**: 2 cores
- **Disk**: 20GB
- **Network**: 1 Gbps

### Proxmox Host Requirements
- **Free RAM**: VM_MEMORY + 1GB overhead
- **Free Disk**: VM_DISK_SIZE + snapshots
- **Network**: Bridge configured
- **Templates**: Debian cloud-init ready
