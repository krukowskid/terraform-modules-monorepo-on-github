output "id" {
  value       = azurerm_user_assigned_identity.this.id
  description = "The ID of created managed identity"
}

output "client_id" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "The client ID of created managed identity"
}

output "principal_id" {
  value       = azurerm_user_assigned_identity.this.principal_id
  description = "The principal ID of created managed identity"
}
