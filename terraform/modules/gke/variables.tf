variable "cluster_name" {
  default = "tgke"
}

variable "kubernetes_version" {
  default = "1.11.7-gke.4"
}

variable "master_ipv4_cidr_block" {}

variable "enable_private_nodes" {}

variable "regional" {}

variable "master_authorized_networks_config_cidr_blocks" {
  type    = "list"
  default = []
}

variable "daily_maintenance_window_start_time" {}

variable "gcp" {
  type    = "map"
  default = {}
}

variable "node-pools" {
  type    = "list"
  default = []
}
