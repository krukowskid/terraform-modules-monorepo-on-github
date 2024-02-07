variable "cluster_name" {
  description = "The name to give to the cluster"
  type        = string
  default     = "kind"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use the KinD cluster (images available https://hub.docker.rom/r/kindest/node/tags[here])."
  type        = string
  default     = "v1.29.0"
}

variable "nodes" {
  description = "List of worker nodes to create in the KinD cluster. To increase the number of nodes, simply duplicate the objects on the list."
  type        = list(map(string))
  default = [
    {
      "platform" = "kinder"
    },
    { "platform" = "kinder"
    },
    {
      "platform" = "kinder"
    },
  ]

  validation {
    condition     = length(var.nodes) >= 3
    error_message = "A minimum of 3 nodes is required because ti simulate a real productive cluster."
  }
}
