output "kube_config" {
  value = azurerm_kubernetes_cluster.odoo-aks-cluster.kube_config_raw

  sensitive = true
}

output "aks-cluster-id" {
  value = azurerm_kubernetes_cluster.odoo-aks-cluster.id
}

output "aks-cluster-name" {
  value = azurerm_kubernetes_cluster.odoo-aks-cluster.name
}

output "aks-cluster-fqdn" {
  value = azurerm_kubernetes_cluster.odoo-aks-cluster.fqdn
}