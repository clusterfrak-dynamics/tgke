resource "google_container_cluster" "zonal_kubernetes_cluster" {
  name               = "${var.cluster_name}"
  zone               = "${var.master_zone}"
  additional_zones   = "${var.additional_zones}"
  min_master_version = "${var.min_master_version}"
  project            = "${var.project}"
  network = "${google_compute_network.kubernetes_network.name}"

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "${var.initial_default_pool_name}"
  }

  master_auth {
    username = "${var.admin_username}"
    password = "${var.admin_password}"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "${var.daily_maintenance_window_start_time}"
    }
  }
}
