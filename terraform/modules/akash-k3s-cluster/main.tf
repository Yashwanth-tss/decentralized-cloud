terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "docker" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
  k3s_data_path = "${var.workspace_path}/k3s-data"
  cgroup_path   = "${var.workspace_path}/cgroup"
  akash_data_path = "${var.workspace_path}/akash-data"
}

# Create k3s server
resource "docker_container" "k3s_server" {
  name  = "k3s-server"
  image = "rancher/k3s:latest"
  command = ["server", "--disable", "traefik", "--disable", "servicelb"]
  
  privileged = true
  network_mode = "host"
  
  env = [
    "K3S_TOKEN=${var.k3s_token}",
    "K3S_KUBECONFIG_MODE=644"
  ]

  volumes {
    host_path      = local.k3s_data_path
    container_path = "/var/lib/rancher/k3s"
  }

  volumes {
    host_path      = local.cgroup_path
    container_path = "/sys/fs/cgroup"
  }
}

# Create namespace for Akash
resource "kubernetes_namespace" "akash" {
  metadata {
    name = "akash-services"
  }
  depends_on = [docker_container.k3s_server]
}

# Create Akash node
resource "docker_container" "akash_node" {
  name  = "akash-node"
  image = "ghcr.io/akash-network/node:latest"
  
  command = ["akash", "start"]
  
  ports {
    internal = var.akash_ports.p2p
    external = var.akash_ports.p2p
  }
  
  ports {
    internal = var.akash_ports.rpc
    external = var.akash_ports.rpc
  }
  
  ports {
    internal = var.akash_ports.api
    external = var.akash_ports.api
  }

  volumes {
    host_path      = local.akash_data_path
    container_path = "/root/.akash"
  }

  env = [
    "AKASH_MONIKER=${var.akash_moniker}",
    "AKASH_CHAIN_ID=${var.akash_chain_id}"
  ]

  depends_on = [kubernetes_namespace.akash]
}

# Wait for containers to be ready
resource "null_resource" "wait_for_containers" {
  depends_on = [docker_container.k3s_server, docker_container.akash_node]

  provisioner "local-exec" {
    command = <<-EOT
      until docker ps | grep -q "akash-node"; do
        echo "Waiting for akash-node container..."
        sleep 5
      done
      until docker ps | grep -q "k3s-server"; do
        echo "Waiting for k3s-server container..."
        sleep 5
      done
    EOT
  }
}

# Initialize Akash node
resource "null_resource" "init_akash" {
  depends_on = [null_resource.wait_for_containers]

  provisioner "local-exec" {
    command = <<-EOT
      # Create data directory
      mkdir -p ${local.akash_data_path}

      # Initialize node
      docker exec akash-node akash init ${var.akash_moniker} --chain-id ${var.akash_chain_id}

      # Create key
      echo "password123" | docker exec -i akash-node akash keys add my-key --keyring-backend file --output json

      # Get key address
      KEY_ADDRESS=$(docker exec akash-node akash keys show my-key -a --keyring-backend file)

      # Add genesis account
      docker exec akash-node akash add-genesis-account $KEY_ADDRESS ${var.akash_genesis_amount}

      # Create validator
      echo "password123" | docker exec -i akash-node akash gentx my-key ${var.akash_stake_amount} --chain-id ${var.akash_chain_id} --keyring-backend file

      # Collect genesis transactions
      docker exec akash-node akash collect-gentxs

      # Restart node
      docker restart akash-node
    EOT
  }
}
