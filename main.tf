resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_role_assignment" "this" {
  for_each             = { for permission in var.permissions : permission.scope => permission }
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_name
}

resource "azurerm_federated_identity_credential" "this" {
  count               = var.oidc.enabled ? 1 : 0
  name                = "${var.oidc.kubernetes_cluster_name}-ServiceAccount-${var.oidc.kubernetes_namespace}-${var.oidc.kubernetes_serviceaccount_name}"
  resource_group_name = var.resource_group_name
  audience            = var.oidc.audience
  issuer              = var.oidc.issuer_url
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = "system:serviceaccount:${var.oidc.kubernetes_namespace}:${var.oidc.kubernetes_serviceaccount_name}"
}
