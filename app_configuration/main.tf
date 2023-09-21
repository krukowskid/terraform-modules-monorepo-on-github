module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "6.1.0" #checkov:skip=CKV_TF_1:Risk accepted

  azure_region = "eu-west"
}

moved {
  from = azurecaf_name.app_configuration
  to   = azurecaf_name.this
}
resource "azurecaf_name" "this" {
  count = local.create_app_configuration
  resource_types = [
    "azurerm_app_configuration"
  ]
  name        = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes    = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes    = [var.caf_resources_suffix]
  clean_input = true
}

resource "azurerm_app_configuration" "this" {
  count               = local.create_app_configuration
  name                = format("%s-%02s", azurecaf_name.this[0].results["azurerm_app_configuration"], var.environment.number)
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.this.location

  sku                        = var.sku_tier
  local_auth_enabled         = var.local_auth_enabled
  public_network_access      = var.public_network_access
  purge_protection_enabled   = var.sku_tier == "standard" ? var.purge_protection : "false"
  soft_delete_retention_days = var.sku_tier == "standard" ? var.soft_delete_retention_days : null

  dynamic "encryption" {
    for_each = var.encryption
    content {
      key_vault_key_identifier = encryption.value.key_vault_key_identifier
      identity_client_id       = encryption.value.identity_client_id
    }
  }

  tags = local.common_tags
}

resource "azurerm_role_assignment" "app_configuration_data_readers" {
  for_each             = var.data_readers
  principal_id         = each.value
  scope                = var.app_configuration_id == null ? azurerm_app_configuration.this[0].id : var.app_configuration_id
  role_definition_name = "App Configuration Data Reader"
}

resource "azurerm_role_assignment" "app_configuration_data_owners" {
  for_each             = var.data_owners
  principal_id         = each.value
  scope                = var.app_configuration_id == null ? azurerm_app_configuration.this[0].id : var.app_configuration_id
  role_definition_name = "App Configuration Data Owner"
}

resource "azurerm_app_configuration_key" "this" {
  for_each               = { for entry in local.configurations : entry.key => entry }
  configuration_store_id = var.app_configuration_id == null ? azurerm_app_configuration.this[0].id : var.app_configuration_id
  key                    = "${var.configurations_key_prefix}:${each.value.key}"
  type                   = each.value.type
  label                  = each.value.label
  value                  = each.value.type == "kv" ? each.value.value : null
  vault_key_reference    = each.value.type == "vault" ? "${var.key_vault_uri}secrets/${each.value.value}" : null
  tags                   = local.common_tags
}
