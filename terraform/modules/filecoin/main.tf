terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "lotus" {
  name = "filecoin/lotus-all-in-one:fb7eeccb7-debug"
}

resource "docker_container" "filecoin_node" {
  name  = "lotus_node"
  image = docker_image.lotus.name
  ports {
    internal = 1234
    external = 1234
  }
  command = ["lotus", "daemon"]
}
