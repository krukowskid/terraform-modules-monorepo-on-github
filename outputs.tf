output "id" {
  description = "App Configuration resource ID."
  value       = var.app_configuration_id == null ? azurerm_app_configuration.this[0].id : null
}

output "name" {
  description = "App Configuration resource name."
  value       = var.app_configuration_id == null ? azurerm_app_configuration.this[0].name : null
}

output "endpoint" {
  description = "App Configuration resource endpoint."
  value       = var.app_configuration_id == null ? azurerm_app_configuration.this[0].endpoint : null
}
