output "managed_identity_id" {
  value       = azurerm_user_assigned_identity.this.id
  description = "The ID of created managed identity"
}

output "managed_identity_client_id" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "The client ID of created managed identity"
}

output "managed_identity_principal_id" {
  value       = azurerm_user_assigned_identity.this.principal_id
  description = "The principal ID of created managed identity"
}
