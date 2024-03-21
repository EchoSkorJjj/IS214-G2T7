variable "project_name" {}
variable "resource_group_name" {}
variable "resource_group_location" {}
variable "db_subnet_id" {}
variable "azurerm_private_dns_zone_id" {}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "odoo_postgresql_flexible" {
  name                   = "${var.project_name}-postgresql-flexible"
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  version                = "12"
  administrator_login    = "odoo16"
  administrator_password = "V!)letEvergarden"
  high_availability {
    mode = "ZoneRedundant"
  }

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone,
    ]
  }

  storage_mb                  = 32768 
  sku_name                    = "GP_Standard_D2s_v3" 
  backup_retention_days       = 7
  private_dns_zone_id = var.azurerm_private_dns_zone_id
  delegated_subnet_id        = var.db_subnet_id
}

resource "azurerm_postgresql_flexible_server_database" "odoo_database" {
  name      = "${var.project_name}-odoo-db"
  server_id = azurerm_postgresql_flexible_server.odoo_postgresql_flexible.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}
