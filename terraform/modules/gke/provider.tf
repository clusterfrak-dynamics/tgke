terraform {
  backend "gcs" {}
}

provider "google" {
  region = "${var.gcp-region}"
}

provider "google-beta" {
  region = "${var.gcp-region}"
}

data "google_compute_regions" "available" {}

data "google_compute_zones" "available" {}

provider "http" {}
