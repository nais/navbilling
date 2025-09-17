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

resource "google_bigquery_dataset" "nais_billing_nav" {
  dataset_id    = "nais_billing_nav"
  friendly_name = "nais_billing_nav"
  description   = "Nav-specific views reading from nais/nais_billing. Managed by terraform in nais/navbilling"
  location      = "europe-north1"
}

resource "google_bigquery_dataset" "focus_billing" {
  dataset_id    = "focus_billing"
  friendly_name = "focus_billing"
  description   = "Billing data on FOCUS format. Managed by terraform in nais/navbilling"
  location      = "EU"
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

resource "google_bigquery_table" "aiven_cost_items" {
  dataset_id  = google_bigquery_dataset.nais_billing_nav.dataset_id
  table_id    = "aiven_cost_items"
  description = "Part of aiven cost items which belongs to nav"

  view {
    query          = file("views/nais_billing_nav/aiven_cost_items.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_aiven_daily" {
  dataset_id  = google_bigquery_dataset.nais_billing_nav.dataset_id
  table_id    = "cost_breakdown_aiven_daily"
  description = "Daily cost breakdown for aiven. Derived from monthly cost"

  view {
    query          = file("views/nais_billing_nav/cost_breakdown_aiven_daily.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_gcp" {
  dataset_id  = google_bigquery_dataset.nais_billing_nav.dataset_id
  table_id    = "cost_breakdown_gcp"
  description = "Cost breakdown for gcp"

  view {
    query          = file("views/nais_billing_nav/cost_breakdown_gcp.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_breakdown_gcp_extended" {
  dataset_id  = google_bigquery_dataset.nais_billing_nav.dataset_id
  table_id    = "cost_breakdown_gcp_extended"
  description = "Extended cost breakdown for gcp. Includes numbers used to calculate cost"

  view {
    query          = file("views/nais_billing_nav/cost_breakdown_gcp_extended.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "focus_v1" {
  dataset_id  = google_bigquery_dataset.nais_billing_nav.dataset_id
  table_id    = "focus_v1"
  description = "Detailed cost breakdown for gcp on FOCUS format"

  view {
    query          = file("views/nais_billing_nav/focus_v1.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "aiven_kafka_cost_monthly" {
  dataset_id  = google_bigquery_dataset.nais_billing_nav.dataset_id
  table_id    = "aiven_kafka_cost_monthly"
  description = "Monthly cost breakdown for Aiven Kafka"

  view {
    query          = file("views/nais_billing_nav/aiven_kafka_cost_monthly.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "focus_billing" {
  dataset_id  = google_bigquery_dataset.focus_billing.dataset_id
  table_id    = "focus_v1"
  description = "Billing data on FOCUS format"

  view {
    query          = file("views/focus_billing/focus_v1.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "cost_anomalies" {
  dataset_id  = google_bigquery_dataset.nais_billing_nav.dataset_id
  table_id    = "cost_anomalies"
  description = "Cost anomalies detected in billing data"
  
  schema = jsonencode([
    {
      name = "anomaly_id"
      type = "STRING"
      mode = "NULLABLE"
      description = "Name or identifier of the detected anomaly"
    },
    {
      name = "resource_name"
      type = "STRING"
      mode = "NULLABLE"
      description = "Name of the resource associated with the anomaly"
    },
    {
      name = "resource_display_name"
      type = "STRING"
      mode = "NULLABLE"
      description = "Display name of the resource"
    },
    {
      name = "detection_date"
      type = "TIMESTAMP"
      mode = "NULLABLE"
      description = "Date and time when the anomaly was detected"
    },
    {
      name = "scope"
      type = "STRING"
      mode = "NULLABLE"
      description = "Scope of the anomaly detection"
    },
    {
      name = "expected_spend"
      type = "FLOAT64"
      mode = "NULLABLE"
      description = "Expected spending amount"
    },
    {
      name = "actual_spend"
      type = "FLOAT64"
      mode = "NULLABLE"
      description = "Actual spending amount"
    },
    {
      name = "deviation_amount"
      type = "FLOAT64"
      mode = "NULLABLE"
      description = "Absolute deviation amount from expected spend"
    },
    {
      name = "deviation_percentage"
      type = "FLOAT64"
      mode = "NULLABLE"
      description = "Percentage deviation from expected spend"
    },
    {
      name = "currency_code"
      type = "STRING"
      mode = "NULLABLE"
      description = "Currency code for the spending amounts"
    },
    {
      name = "root_causes_json"
      type = "STRING"
      mode = "NULLABLE"
      description = "JSON string containing root cause analysis"
    },
    {
      name = "processed_at"
      type = "TIMESTAMP"
      mode = "NULLABLE"
      description = "Timestamp when the record was processed"
    }
  ])
  }