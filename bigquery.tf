resource "google_bigquery_dataset" "navbilling" {
  dataset_id    = "navbilling"
  friendly_name = "navbilling"
  description   = "Managed by terraform in nais/navbilling"
  location      = "europe-north1"
}

resource "google_bigquery_table" "cost_breakdown_aiven" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_aiven"
  description = "Billing from aiven formatted to match gcp billing"

  view {
    query          = file("views/cost_breakdown_aiven.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_excluding_nais" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_excluding_nais"
  description = "Billing from gcp for all projects excluding nais clusters as there is a separate logic for cost allocation in kubernetes"

  view {
    query          = file("views/cost_breakdown_excluding_nais.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_nais" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_nais"
  description = "Billing for nais clusters allocated to namespaces and applications"

  view {
    query          = file("views/cost_breakdown_nais.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_total" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_total"
  description = "Combines all gcp and aiven billing"

  view {
    query          = file("views/cost_breakdown_total.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "gcp_billing_export" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "gcp_billing_export"
  description = "Combines gcp billing from different points in time"

  view {
    query          = file("views/gcp_billing_export.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "gcp_projects_derived" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "gcp_projects_derived"
  description = "Data cleansing for gcp projects table"

  view {
    query          = file("views/gcp_projects_derived.sql")
    use_legacy_sql = false
  }
}
