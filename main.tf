terraform {
  backend "gcs" {}
}

data "terraform_remote_state" "gke_cluster" {
  backend = "gcs"
  config {
    bucket = "${var.gke_cluster_remote_state["bucket"]}"
    prefix = "${var.gke_cluster_remote_state["prefix"]}"
  }
}
data "google_client_config" "current" {}

provider "google" {
  region = "${var.provider["region"]}"
  project = "${var.provider["project"]}"
}

provider "helm" {
  tiller_image = "gcr.io/kubernetes-helm/tiller:${lookup(var.helm, "version", "v2.11.0")}"

  install_tiller = true
  service_account = "${data.terraform_remote_state.gke_cluster.tiller_service_account}"
  namespace = "kube-system"

  kubernetes {
    host                   = "${data.terraform_remote_state.gke_cluster.endpoint}"
    token                  = "${data.google_client_config.current.access_token}"
    cluster_ca_certificate = "${base64decode(data.terraform_remote_state.gke_cluster.cluster_ca_certificate)}"
  }
}

resource "helm_release" "postgresql" {
  name      = "postgresql"
  chart     = "stable/postgresql"
  namespace = "postgresql"
  values = [
    "${file(lookup(var.helm, "values", "values.yaml"))}"
  ]
}