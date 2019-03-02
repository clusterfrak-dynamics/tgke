resource "google_container_cluster" "regional_kubernetes_cluster" {
  provider = "google-beta"
  name               = "${var.cluster_name}"
  region             = "${var.master_region}"
  min_master_version = "${var.min_master_version}"
  project            = "${var.project}"
  network            = "${google_compute_network.kubernetes_network.name}"
  initial_node_count = 1

  remove_default_node_pool = true

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
    enable_private_nodes   = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  master_auth {
    password = ""
    username = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service= "monitoring.googleapis.com/kubernetes"

  master_authorized_networks_config {
    cidr_blocks = [
      {
        cidr_block   = "0.0.0.0/0"
        display_name = "everywhere"
      },
    ]
  }
}

resource "google_container_node_pool" "regional-np" {
  name       = "${var.pool_name}"
  region     = "${var.master_region}"
  cluster    = "${google_container_cluster.kubernetes_cluster.name}"
  node_count = 1
}

output "kubernetes_api_endpoint" {
  value = "${google_container_cluster.kubernetes_cluster.endpoint}"
  provider = "google-beta"
}
