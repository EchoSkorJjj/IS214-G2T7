variable "project_name" {}
variable "resource_group_name" {}
variable "resource_group_location" {}
variable "private_subnet_id" {}
variable "environment" {}

resource "azurerm_kubernetes_cluster" "odoo-aks-cluster" {
  name                = "${var.project_name}-aks-cluster"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project_name}-odoo-aks"
  private_cluster_enabled = false

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    zones      = ["1", "2"]
    max_count = 3
    min_count = 2
    enable_auto_scaling = true
    vnet_subnet_id = var.private_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.0.6.0/24"  # Adjusted to avoid overlap
    dns_service_ip     = "10.0.6.10"    # Must be within the service_cidr range
  }

  tags = {
    Environment = var.environment
  }
}