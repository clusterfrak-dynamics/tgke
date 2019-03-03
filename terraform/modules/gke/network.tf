resource "google_compute_network" "kubernetes_network" {
  name                    = "gke-${var.cluster_name}-network"
  auto_create_subnetworks = "true"
}
