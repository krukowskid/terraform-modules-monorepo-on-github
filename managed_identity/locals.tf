locals {
  tags = merge({
    environment = var.environment,
    terraform   = true
  }, var.common_tags)
}
