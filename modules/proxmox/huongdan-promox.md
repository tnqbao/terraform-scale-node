# Hướng dẫn sử dụng Provider Proxmox với Terraform

File này giải thích cách module `promox` hoạt động với provider Proxmox trong dự án này.

## 1. Provider Proxmox là gì?
Provider Proxmox cho phép Terraform kết nối và quản lý tài nguyên (máy ảo, ổ đĩa, v.v.) trên hệ thống Proxmox VE thông qua API.

## 2. Cách hoạt động của module `promox`

### a. Khai báo biến đầu vào
Module sử dụng các biến đầu vào trong file `variables.tf` để cấu hình máy ảo:
- `pm_api_url`: Địa chỉ API của Proxmox.
- `pm_user`, `pm_password`: Tài khoản đăng nhập Proxmox.
- `target_node`: Tên node Proxmox sẽ tạo máy ảo.
- `vm_name`: Tên máy ảo.
- `vm_memory`: Dung lượng RAM (MB).
- `vm_cores`: Số lượng CPU.
- `iso_file`: Đường dẫn file ISO cài đặt.
- `vm_disk_size`: Dung lượng ổ đĩa (GB).

### b. Cấu hình provider
Trong file `main.tf` của module, provider Proxmox sẽ được cấu hình sử dụng các biến trên để kết nối tới Proxmox.

### c. Tạo máy ảo tự động
Khi chạy `terraform apply`, Terraform sẽ sử dụng provider Proxmox để gọi API và tự động tạo máy ảo theo thông số đã khai báo.

## 3. Quy trình sử dụng
1. Khai báo các biến đầu vào trong file `.tfvars` hoặc qua dòng lệnh.
2. Chạy `terraform init` để khởi tạo dự án.
3. Chạy `terraform apply` để tạo máy ảo trên Proxmox.

## 4. Lợi ích
- **Tự động hóa**: Không cần thao tác thủ công trên giao diện Proxmox.
- **Lặp lại dễ dàng**: Có thể tạo lại máy ảo với cấu hình giống nhau bất cứ lúc nào.
- **Quản lý bằng mã nguồn**: Dễ dàng kiểm soát, thay đổi và chia sẻ cấu hình.

---
Nếu cần thêm ví dụ hoặc hướng dẫn chi tiết, hãy xem file `main.tf` trong module hoặc liên hệ quản trị viên dự án.

