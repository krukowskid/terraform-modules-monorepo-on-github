variable "project_name" {
  type        = string
  description = "Project name."
}

variable "environment" {
  type = object({
    name   = string
    number = number
  })
  description = "Environment name and number."
}

variable "caf_name" {
  type        = string
  description = "CAF custom basename of the resource to create."
  default     = ""
}

variable "caf_resources_suffix" {
  type        = string
  description = "Defines CAF resources suffix."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name where App Configuration will be created."
}

variable "app_configuration_id" {
  type        = string
  description = "App Configuration ID created outside of the module."
  default     = null
}

variable "sku_tier" {
  type        = string
  description = "The SKU name of the App Configuration."
  default     = "standard"
  validation {
    condition     = contains(["free", "standard"], var.sku_tier)
    error_message = "Invalid SKU Tier. Valid values: free, standard."
  }
}

variable "local_auth_enabled" {
  type        = bool
  description = "Whether local authentication methods is enabled."
  default     = false
}

variable "public_network_access" {
  type        = string
  description = "The Public Network Access setting of the App Configuration."
  default     = "Disabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Invalid Public Network Access. Valid values: Enabled, Disabled."
  }
}

variable "purge_protection" {
  type        = bool
  description = "Whether Purge Protection is enabled."
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted."
  default     = 7
  validation {
    condition = (
      var.soft_delete_retention_days >= 1 &&
      var.soft_delete_retention_days <= 7
    )
    error_message = "Invalid retention period. Number must be between 1 and 7."
  }
}

variable "configurations_key_prefix" {
  type        = string
  description = "Prefix value that will be applied to all passed keys: 'app_configuration_key_prefix:each_passed_key'."
}

variable "data_readers" {
  type        = map(string)
  description = "Defines list of AD Objects ID to be assigned to app configuration Data Readers role."
  default     = {}
}

variable "data_owners" {
  type        = map(string)
  description = "Defines list of AD Objects ID to be assigned to app configuration Data Owner role."
  default     = {}
}

variable "key_vault_uri" {
  type        = string
  description = "Keyvault URI which will be appended to reference values to build full seecret reference."
  default     = ""
}

variable "configurations" {
  type = list(object({
    values = map(any)
    type   = string
    label  = string
  }))
  default     = []
  description = "List of user provided config to upload into app configuration service."
  validation {
    condition = alltrue([
      for config in var.configurations : contains(["kv", "vault"], config.type)
    ])
    error_message = "The type must be 'kv' for key=value or 'vault' for key=vault_reference."
  }
}

variable "encryption" {
  type = list(object({
    key_vault_key_identifier = optional(string)
    identity_client_id       = optional(string)
  }))
  description = "Defines App Configuration encryption block"
  default     = []
}

variable "common_tags" {
  type        = map(string)
  description = "A mapping of additional tags to assign to the resources."
  default     = {}
}
