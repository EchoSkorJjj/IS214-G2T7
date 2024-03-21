variable "project_name" {}
variable "resource_group_name" {}
variable "resource_group_location" {}
variable "public_subnet_id" {}
variable "public_ip_id" {}
variable "environment" {}

resource "azurerm_bastion_host" "bastion" {
  name                = "${var.project_name}-bastion-host"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.public_subnet_id
    public_ip_address_id = var.public_ip_id
  }

  tags = {
    Environment = var.environment
  }
}