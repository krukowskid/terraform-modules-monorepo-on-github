variable "name" {
  type        = string
  description = "Managed identity name."
}

variable "environment" {
  type        = string
  description = "The name of environment."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the managed identity"
}

variable "location" {
  type        = string
  description = "The location/region where the managed identity is created."
}

variable "permissions" {
  type = list(object({
    scope                            = string
    role_name                        = string
    skip_service_principal_aad_check = optional(bool, false)
  }))
  description = "Defines a list of role names and scopes to assign to the managed identity."
  default     = []
}

variable "common_tags" {
  type        = map(string)
  description = "Defines additional, custom values used during tagging resources."
  default     = {}
}

variable "oidc" {
  type = object({
    enabled                        = bool
    audience                       = optional(list(string), ["api://AzureADTokenExchange"])
    issuer_url                     = string
    kubernetes_namespace           = string
    kubernetes_serviceaccount_name = string
    kubernetes_cluster_name        = string
  })
  description = "Configure OIDC federation settings to establish a trusted token mechanism between the Kubernetes cluster and external systems."
  default = {
    enabled                        = false
    issuer_url                     = ""
    kubernetes_namespace           = ""
    kubernetes_serviceaccount_name = ""
    kubernetes_cluster_name        = ""
  }
}
