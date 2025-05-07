terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "ipfs" {
  name = "ipfs/go-ipfs:latest"
}

resource "docker_container" "ipfs_node" {
  name  = "ipfs_node"
  image = docker_image.ipfs.name
  ports {
    internal = 5001
    external = 5001
  }

  ports {
    internal = 4001
    external = 4001
  }

  ports {
    internal = 8080
    external = 8080
  }
}
