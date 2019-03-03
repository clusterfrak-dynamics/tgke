terraform {
  backend "gcs" {}
}

provider "google" {
  region  = "${var.gcp["region"]}"
  project = "${var.gcp["project"]}"
}

provider "google-beta" {
  region  = "${var.gcp["region"]}"
  project = "${var.gcp["project"]}"
}

data "google_compute_regions" "available" {}

data "google_compute_zones" "available" {}
