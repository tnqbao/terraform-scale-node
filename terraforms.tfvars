cloud_provider = "proxmox"

vm_name        = "debian-test"
target_node    = "pve"
iso_file       = "local:iso/debian-12.5.0-amd64-netinst.iso"
vm_memory      = 3072
vm_cores       = 2
vm_disk_size   = "30G"

# cloud_provider = "aws"
#
# vm_name        = "debian-aws"
# aws_region     = "us-east-1"
# ami_id         = "ami-0abc1234def567890"
# instance_type  = "t2.micro"

# cloud_provider = "gcp"
#
# vm_name     = "debian-gcp"
# gcp_project = "project-id"
# gcp_region  = "us-central1"
# gcp_zone    = "us-central1-a"
# gcp_image   = "debian-cloud/debian-12"

