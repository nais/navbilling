terraform {
  backend "gcs" {
    bucket = "navbilling-terraform-dev"
    prefix = "state"
  }
}

provider "google" {
  project = "nais-analyse-dev-8caa"
  region  = "europe-north1"
}