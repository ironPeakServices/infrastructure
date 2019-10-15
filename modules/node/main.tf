provider "scaleway" {
  version          = "~> 1.11.0"
  region           = "${var.scaleway_region}"
  organization_id  = "${var.scaleway_organization}"
  secret_key       = "${var.scaleway_api_token}"
}

resource "scaleway_account_ssh_key" "cicd_root_key" {
    name       = "CI/CD Root public key"
    public_key = "${var.ssh_root_public_key}"
}

data "scaleway_image" "docker" {
  architecture = "${var.node_arch}"
  name         = "Docker"
}

data "template_file" "ssh_conf" {
  template = "${file("${path.module}/conf/ssh.tpl")}"

  vars = {
    port = "${var.ssh_port}"
  }
}