output "key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}

output "bastion_host_ssh_private_key" {
  value = azapi_resource_action.ssh_public_key_gen.response_content.privateKey
}

output "bastion_host_ssh_public_key" {
  value = azapi_resource_action.ssh_public_key_gen.response_content.publicKey
}