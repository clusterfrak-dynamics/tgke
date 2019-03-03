terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "../../../modules//gke"
  }
}

//
// [provider]
//
gcp = {
  region = "europe-west1"
  project = "tgke-233413"
}

//
// [kubernetes]
//
cluster-name = "sample"
kubernetes_version = "1.11.7-gke.4"
master_ipv4_cidr_block = "172.16.0.0/28"
enable_private_nodes = true
regional = false
daily_maintenance_window_start_time = "03:00"
master_authorized_networks_config_cidr_blocks = [
  {
    cidr_block = "0.0.0.0/0",
    display_name = "anywhere"
  }
]

//
// [node-pools]
//
node-pools = [
  {
    name = "default"
    min_node_count = 1
    max_node_count = 1
    initial_node_count = 1
    machine_type = "n1-standard-1"
    image_type = "COS_CONTAINERD"
    key_name = "keypair"
    disk_size_gb = 30
    disk_type = "pd-ssd"
    preemptible = false
    version = "1.11.7-gke.4"
    auto_repair = true
    auto_upgrade = false
  },
]
