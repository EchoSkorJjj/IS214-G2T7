# Output for Virtual Network
output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "virtual_network_address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

# Output for Public Subnet for Bastion
output "public_subnet_name" {
  value = azurerm_subnet.bastion_public_subnet.name
}

output "public_subnet_id" {
  value = azurerm_subnet.bastion_public_subnet.id
}

# Output for Public IP for Bastion
output "public_ip_name" {
  value = azurerm_public_ip.bastion_public_ip.name
}

output "public_ip_id" {
  value = azurerm_public_ip.bastion_public_ip.id
}

# Output for Private Subnet for AKS
output "private_subnet_name" {
  value = azurerm_subnet.aks_private_subnet.name
}

output "private_subnet_id" {
  value = azurerm_subnet.aks_private_subnet.id
}

# Output for Azure PostgreSQL Subnet
output "db_subnet_name" {
  value = azurerm_subnet.db_subnet.name
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "azurerm_private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgresql_dns_zone.id
}

# Output for Network Security Group for Private Subnet
output "private_nsg_name" {
  value = azurerm_network_security_group.private_nsg.name
}

output "private_nsg_id" {
  value = azurerm_network_security_group.private_nsg.id
}

# Output for Network Security Group for DB Subnet
output "db_nsg_name" {
  value = azurerm_network_security_group.db_nsg.name
}

output "db_nsg_id" {
  value = azurerm_network_security_group.db_nsg.id
}
