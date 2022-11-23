terraform {
  backend "gcs" {
    bucket = "navbilling-terraform-prod"
    prefix = "state"
  }
}

provider "google" {
  project = "nais-analyse-prod-2dcc"
  region  = "europe-north1"
}
