variable "client_id" {
  type        = string
  description = "Azure Service Principal App ID."
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Azure Service Principal Secret."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID."
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID."
  sensitive   = true
}

variable "artifacts_resource_group" {
  type        = string
  description = "Packer Artifacts Resource Group."
}

variable "build_resource_group" {
  type        = string
  description = "Packer Build Resource Group."
}

source "azure-arm" "avd" {
  # WinRM Communicator

  communicator = "winrm"
  winrm_use_ssl = true
  winrm_insecure = true
  winrm_timeout = "10m"
  winrm_username = "packer"

  # Service Principal Authentication

  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  # Source Image

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsDesktop"
  image_offer     = "office-365"
  image_sku       = "win11-21h2-avd-m365"
  # Windows 11 without Office
  #image_offer     = "windows-11"
  #image_sku       = "win11-21h2-avd"

  # Destination Image

  managed_image_resource_group_name = var.artifacts_resource_group
  managed_image_name                = "windows-11-m365-mimg"

  # Packer Computing Resources

  build_resource_group_name = var.build_resource_group
  vm_size                   = "Standard_D4ds_v4"
}

build {
  source "azure-arm.avd" {}
}
