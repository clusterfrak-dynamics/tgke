resource "google_container_cluster" "zonal_kubernetes_cluster" {
  provider = "google-beta"
  count    = "${var.regional ? 0 : 1 }"

  name               = "${var.cluster_name}"
  zone               = "${data.google_compute_zones.available.names[0]}"
  additional_zones   = ["${slice(data.google_compute_zones.available.names, 1, length(data.google_compute_zones.available.names))}"]
  min_master_version = "${var.kubernetes_version}"
  network            = "${google_compute_network.kubernetes_network.name}"
  initial_node_count = 1

  remove_default_node_pool = true

  maintenance_policy {
    daily_maintenance_window {
      start_time = "${var.daily_maintenance_window_start_time}"
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  pod_security_policy_config {
    enabled = true
  }

  network_policy {
    enabled = true
  }

  addons_config {
    network_policy_config {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = true
    }

    http_load_balancing {
      disabled = true
    }
  }

  private_cluster_config {
    enable_private_nodes   = "${var.enable_private_nodes}"
    master_ipv4_cidr_block = "${var.master_ipv4_cidr_block}"
  }

  master_auth {
    password = ""
    username = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  master_authorized_networks_config {
    cidr_blocks = "${var.master_authorized_networks_config_cidr_blocks}"
  }
}

resource "google_container_node_pool" "zonal_node_pool" {
  provider = "google-beta"
  count    = "${var.regional ? 0 : length(var.node-pools)}"
  name     = "gke-${var.cluster_name}-${lookup(var.node-pools[count.index],"name")}"
  zone     = "${data.google_compute_zones.available.names[count.index % 3]}"
  cluster  = "${google_container_cluster.zonal_kubernetes_cluster.name}"

  version            = "${lookup(var.node-pools[count.index],"version")}"
  initial_node_count = "${lookup(var.node-pools[count.index],"initial_node_count")}"

  node_config {
    preemptible  = "${lookup(var.node-pools[count.index],"preemptible")}"
    machine_type = "${lookup(var.node-pools[count.index],"machine_type")}"
    image_type   = "${lookup(var.node-pools[count.index],"image_type")}"
    disk_type    = "${lookup(var.node-pools[count.index],"disk_type")}"
    disk_size_gb = "${lookup(var.node-pools[count.index],"disk_size_gb")}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  management {
    auto_repair  = "${lookup(var.node-pools[count.index],"auto_repair")}"
    auto_upgrade = "${lookup(var.node-pools[count.index],"auto_upgrade")}"
  }

  autoscaling {
    min_node_count = "${lookup(var.node-pools[count.index],"min_node_count")}"
    max_node_count = "${lookup(var.node-pools[count.index],"max_node_count")}"
  }
}

output "zonal_kubernetes_api_endpoint" {
  value = "${google_container_cluster.zonal_kubernetes_cluster.*.endpoint}"
}

output "zonal_kubernetes_cluster_ca_certificate" {
  value = "${google_container_cluster.zonal_kubernetes_cluster.*.master_auth.0.cluster_ca_certificate}"
}
