# Root Terraform file: main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.25.0"  # Or latest stable
    }
  }
}

provider "docker" {}

# --- Localhost Simulation for Akash Node ---
module "akash_node" {
  source = "./modules/akash"
    providers = {
    docker = docker
  }
}

# --- IPFS Node ---
module "ipfs_node" {
  source = "./modules/ipfs"
    providers = {
    docker = docker
  }
}

# --- Filecoin (optional backup node) ---
module "filecoin_node" {
  source = "./modules/filecoin"
    providers = {
    docker = docker
  }
}

# --- Monitoring Stack ---
module "monitoring" {
  source = "./modules/monitoring"
    providers = {
    docker = docker
  }
}

output "ipfs_container_id" {
  value = module.ipfs_node.container_id
}

output "akash_container_id" {
  value = module.akash_node.container_id
}

output "prometheus_url" {
  value = module.monitoring.prometheus_url
}

output "grafana_url" {
  value = module.monitoring.grafana_url
}
