output "bastion_host_id" {
    value = azurerm_bastion_host.bastion.id
}

output "bastion_host_dns_name" {
    value = azurerm_bastion_host.bastion.dns_name
}