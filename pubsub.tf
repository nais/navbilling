locals {
  project = "nais-analyse-prod-2dcc"
}

resource "google_pubsub_topic" "cost_anomalies" {
  name    = "cost-anomalies"
}

resource "google_service_account" "cost_anomalies_sa" {
  account_id   = "cost-anomalies-sa"
  display_name = "Cost Anomalies Service Account"
}

resource "google_project_iam_member" "eventreceiver" {
  project = local.project
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.cost_anomalies_sa.email}"
}

resource "google_project_iam_member" "runinvoker" {
  project = local.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cost_anomalies_sa.email}"
}
