terraform {
  required_providers {
    k3s = {
      source  = "xunleii/k3s"
      version = "0.12.1"
    }
  }
}

provider "k3s" {
  kubeconfig_path = pathexpand("~/.kube/config")
}

provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

resource "k3s_cluster" "local" {
  cluster_name = "akash-k3s-cluster"
  disable {
    components = ["traefik"]  # Optional, disables built-in Traefik ingress
  }
}

resource "null_resource" "install_helm" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/install_helm.sh"
  }
}

resource "helm_release" "akash_provider" {
  name       = "akash-provider"
  repository = "https://akash-network.github.io/helm-charts"
  chart      = "provider"
  namespace  = "akash-services"
  version    = "11.6.3"

  create_namespace = true

  set {
    name  = "debug"
    value = "true"
  }

  depends_on = [k3s_cluster.local, null_resource.install_helm]
}
