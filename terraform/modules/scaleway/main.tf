terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 1.16"
    }
  }
}

data "external" "get_kubernetes_version" {
  program = ["${path.module}/extract-kubernetes-version.sh", "${path.module}/../../.github/kubernetes/go.mod"]
}

resource "scaleway_k8s_cluster_beta" "ironpeakbe-main-cluster" {
    name = var.cluster_name
    version = var.k8s_version == "" ? data.external.get_kubernetes_version.result.version : var.k8s_version
    tags = [ "k8s", "ironpeakbe", "main-cluster", "prd" ]
    
    enable_dashboard = false

    ingress = "none"
    cni = "cilium"
    // admission_plugins =
    // feature_gates =
}

resource "scaleway_k8s_pool_beta" "ironpeakbe-main-pool" {
    cluster_id = scaleway_k8s_cluster_beta.ironpeakbe-main-cluster.id

    name = "ironpeakbe-main-pool"
    node_type = var.node_type

    size = var.node_default_count
    min_size = var.node_minimum_count
    max_size = var.node_maximum_count

    autoscaling = true
    autohealing = true

    container_runtime = "containerd"

    // placement_group_id
}