variable host {}

variable token {}

variable cluster_ca_certificate {}

variable cluster_name {}

variable kubeconfig_path {
  default = "../../kubeconfig"
}

variable istio_namespace {
  default = "system-istio"
}
