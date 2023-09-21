locals {
  create_app_configuration = var.app_configuration_id == null ? 1 : 0
  configurations = flatten([
    for label_key, config in var.configurations : [
      for entry_key, entry in config.values : {
        key   = entry_key
        value = entry
        label = config.label
        type  = config.type
      }
    ]
  ])
  common_tags = merge({
    environment = var.environment.name,
    terraform   = true
  }, var.common_tags)
}
