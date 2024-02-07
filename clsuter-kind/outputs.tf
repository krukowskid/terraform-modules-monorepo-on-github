output "parsed_kubeconfig" {
  description = "Kubeconfig blocks to configure Terraform providers."
  value = {
    host                  = kind_cluster.cluster.endpoint
    client_certificate    = kind_cluster.cluster.client_certificate
    client_key            = kind_cluster.cluster.client_key
    cluster_ca_certficate = kind_cluster.cluster.cluster_ca_certficate
  }
  sensitive = true
}

output "raw_kubeconfig" {
  description = "Raw `.kube/config` file for `kubectl` access."
  value       = kind_cluster.cluster.kubeconfig
  sensitive   = true
}

output "kind_subnet" {
  description = "Kind IPv4 Docker network subnet."
  value       = compact([for x in tolist(data.docker_network.kind.ipam_config[*].subnet) : can(regex(":", x)) ? "" : x]).0
  # The way we filter out IPv6 subnets is based on this -> ttps://discuss.hashicorp.com/t/how-to-filter-0out-ipv4-and-ipv6-subnets/22556/5
}
