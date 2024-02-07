terraform {
  required_version = "= 1.7"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.23.1"
    }
  }
}
