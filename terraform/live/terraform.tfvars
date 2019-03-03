terragrunt = {
  remote_state {
    backend = "gcs"
    config {
      bucket         = "tgke-terraform-remote-state"
      prefix         = "${path_relative_to_include()}"
      region         = "europe-west1"
    }
  }
}
