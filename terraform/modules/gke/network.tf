resource "google_compute_network" "kubernetes_network" {
  name                    = "${var.kubernetes_network_name}-${var.env}"
  auto_create_subnetworks = "true"
  project = "${var.project}"
}
