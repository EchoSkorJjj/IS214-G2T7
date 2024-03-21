# Output for Virtual Network
output "virtual_network_name" {
  value = module.virtual-network.virtual_network_name
}

output "virtual_network_id" {
  value = module.virtual-network.virtual_network_id
}

output "virtual_network_address_space" {
  value = module.virtual-network.virtual_network_address_space
}

# Output for Public Subnet for Bastion
output "public_subnet_name" {
  value = module.virtual-network.public_subnet_name
}

output "public_subnet_id" {
  value = module.virtual-network.public_subnet_id
}

# Output for Public IP for Bastion
output "public_ip_name" {
  value = module.virtual-network.public_ip_name
}

output "public_ip_id" {
  value = module.virtual-network.public_ip_id
}

# Output for Private Subnet for AKS
output "private_subnet_name" {
  value = module.virtual-network.private_subnet_name
}

output "private_subnet_id" {
  value = module.virtual-network.private_subnet_id
}

# Output for Azure PostgreSQL Subnet
output "db_subnet_name" {
  value = module.virtual-network.db_subnet_name
}

output "db_subnet_id" {
  value = module.virtual-network.db_subnet_id
}

output "azurerm_private_dns_zone_id" {
  value = module.virtual-network.azurerm_private_dns_zone_id
}

# Output for Network Security Group for Private Subnet
output "private_nsg_name" {
  value = module.virtual-network.private_nsg_name
}

output "private_nsg_id" {
  value = module.virtual-network.private_nsg_id
}

# Output for Network Security Group for DB Subnet
output "db_nsg_name" {
  value = module.virtual-network.db_nsg_name
}

output "db_nsg_id" {
  value = module.virtual-network.db_nsg_id
}

output "bastion_host_id" {
  value = module.bastion.bastion_host_id
}

output "bastion_host_dns_name" {
  value = module.bastion.bastion_host_dns_name
}

output "kube_config" {
  value = module.kubernetes.kube_config

  sensitive = true
}

output "aks-cluster-id" {
  value = module.kubernetes.aks-cluster-id
}

output "aks-cluster-name" {
  value = module.kubernetes.aks-cluster-name
}

output "aks-cluster-fqdn" {
  value = module.kubernetes.aks-cluster-fqdn
}

output "odoo-postgresql-id" {
  value = module.postgresql.odoo-postgresql-id
}

output "odoo-postgresql-fqdn" {
  value = module.postgresql.odoo-postgresql-fqdn
}