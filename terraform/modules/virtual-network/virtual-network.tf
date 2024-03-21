variable "project_name" {}
variable "resource_group_name" {}
variable "resource_group_location" {}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name 
}

# Public Subnet for Bastion
resource "azurerm_subnet" "bastion_public_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP for Bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "${var.project_name}-bastion-public-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Private Subnet for AKS
resource "azurerm_subnet" "aks_private_subnet" {
  name                 = "${var.project_name}-aks-private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_rule" "allow_all_inbound" {
  name                        = "AllowAllInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_nsg.name
}

resource "azurerm_network_security_rule" "allow_http_inbound" {
  name                        = "AllowHTTPInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = azurerm_subnet.aks_private_subnet.address_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_nsg.name
}


# Subnet for Azure PostgreSQL
# Enabling Service Endpoints on PostgreSQL Subnet
resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.project_name}-db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "postgresql_dns_zone" {
  name                = "private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_vnet_link" {
  name                  = "${var.project_name}-postgresql-dns-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgresql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = var.resource_group_name
  depends_on            = [azurerm_subnet.db_subnet]
}

# Network Security Group for Private Subnet
resource "azurerm_network_security_group" "private_nsg" {
  name                = "${var.project_name}-private-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Associate NSG to Private Subnet
resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

# Network Security Group for DB Subnet
resource "azurerm_network_security_group" "db_nsg" {
  name                = "${var.project_name}-db-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Associate NSG to DB Subnet
resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

resource "azurerm_network_security_rule" "allow_bastion_to_postgresql" {
  name                        = "AllowBastionToPostgreSQL"
  priority                    = 100 
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"  
  source_address_prefix       = azurerm_subnet.bastion_public_subnet.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.db_subnet.address_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.db_nsg.name
}


resource "azurerm_network_security_rule" "allow_aks_to_postgresql" {
  name                        = "AllowAksToPostgreSQL"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = azurerm_subnet.aks_private_subnet.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.db_subnet.address_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.db_nsg.name
}
