module "proxmox_vm" {
  source       = "./modules/proxmox"
  count        = var.cloud_provider == "proxmox" ? 1 : 0
  vm_name      = var.vm_name
  vm_memory    = var.vm_memory
  vm_cores     = var.vm_cores
  pm_api_url   = var.pm_api_url
  pm_user      = var.pm_user
  pm_password  = var.pm_password
  target_node  = var.target_node
  iso_file     = var.iso_file
  vm_disk_size = var.vm_disk_size
}

module "aws_vm" {
  source        = "./modules/aws"
  count         = var.cloud_provider == "aws" ? 1 : 0
  vm_name       = var.vm_name
  aws_region    = var.aws_region
  ami_id        = var.ami_id
  instance_type = var.instance_type
}

module "gcp_vm" {
  source      = "./modules/gcp"
  count       = var.cloud_provider == "gcp" ? 1 : 0
  vm_name     = var.vm_name
  vm_memory   = var.vm_memory
  vm_cores    = var.vm_cores
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  gcp_image   = var.gcp_image
}
