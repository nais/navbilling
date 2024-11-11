resource "google_bigquery_dataset" "navbilling" {
  dataset_id    = "navbilling"
  friendly_name = "navbilling"
  description   = "Managed by terraform in nais/navbilling"
  location      = "europe-north1"
}

resource "google_bigquery_dataset" "nais_billing_tenants" {
  dataset_id    = "nais_billing_tenants"
  friendly_name = "nais_billing_tenants"
  description   = "The aim of this dataset is to easily access tenant billing data in Metabase for those who need it. Managed by terraform in nais/navbilling"
  location      = "europe-north1"
}

resource "google_bigquery_table" "cost_breakdown_aiven" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_aiven"
  description = "Billing from aiven formatted to match gcp billing"

  view {
    query          = file("views/navbilling/cost_breakdown_aiven.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_excluding_nais" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_excluding_nais"
  description = "Billing from gcp for all projects excluding nais clusters as there is a separate logic for cost allocation in kubernetes"

  view {
    query          = file("views/navbilling/cost_breakdown_excluding_nais.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_nais" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_nais"
  description = "Billing for nais clusters allocated to namespaces and applications"

  view {
    query          = file("views/navbilling/cost_breakdown_nais.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_total" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "cost_breakdown_total"
  description = "Combines all gcp and aiven billing"

  view {
    query          = file("views/navbilling/cost_breakdown_total.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "gcp_billing_export" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "gcp_billing_export"
  description = "Combines gcp billing from different points in time"

  view {
    query          = file("views/navbilling/gcp_billing_export.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "gcp_projects_derived" {
  dataset_id  = google_bigquery_dataset.navbilling.dataset_id
  table_id    = "gcp_projects_derived"
  description = "Data cleansing for gcp projects table"

  view {
    query          = file("views/navbilling/gcp_projects_derived.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "monthly_tenant_billing" {
  dataset_id  = google_bigquery_dataset.nais_billing_tenants.dataset_id
  table_id    = "monthly_tenant_billing"
  description = "Exact tenant cost per invoice month"

  view {
    query          = file("views/nais_billing_tenants/monthly_tenant_billing.sql")
    use_legacy_sql = false
  }
}
