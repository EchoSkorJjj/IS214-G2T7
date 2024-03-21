variable "project_name" {}
variable "azure_region" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.96.0"
    }
  }
}

provider "azurerm" {
  # skip_provider_registration = false
  features {}
}

resource "azurerm_resource_group" "odoo_resource_group" {
  name     = "${var.project_name}-odoo-resource-group"
  location = var.azure_region
}

# module "ssh" {
#   source = "./ssh"

#   project_name = var.project_name
#   resource_group_id = azurerm_resource_group.odoo_resource_group.id
#   resource_group_location = azurerm_resource_group.odoo_resource_group.location
# }

module "virtual-network" {
  source = "./virtual-network"

  project_name = var.project_name
  resource_group_name = azurerm_resource_group.odoo_resource_group.name
  resource_group_location = azurerm_resource_group.odoo_resource_group.location
}

module "bastion" {
  source = "./bastion"

  project_name = var.project_name
  resource_group_name = azurerm_resource_group.odoo_resource_group.name
  resource_group_location = azurerm_resource_group.odoo_resource_group.location
  public_subnet_id = module.virtual-network.public_subnet_id
  public_ip_id = module.virtual-network.public_ip_id
}

module "kubernetes" {
  source = "./aks"

  project_name = var.project_name
  resource_group_name = azurerm_resource_group.odoo_resource_group.name
  resource_group_location = azurerm_resource_group.odoo_resource_group.location
  private_subnet_id = module.virtual-network.private_subnet_id
}

module "postgresql" {
  source = "./postgresql"

  project_name = var.project_name
  resource_group_name = azurerm_resource_group.odoo_resource_group.name
  resource_group_location = azurerm_resource_group.odoo_resource_group.location
  db_subnet_id = module.virtual-network.db_subnet_id
  azurerm_private_dns_zone_id = module.virtual-network.azurerm_private_dns_zone_id
}