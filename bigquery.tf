resource "google_bigquery_dataset" "test_dataset" {
  dataset_id    = "test_dataset"
  friendly_name = "test_dataset"
  description   = "Testing terraform"
  location      = "europe-north1"
}

resource "google_bigquery_table" "test_view" {
  dataset_id = google_bigquery_dataset.test_dataset.dataset_id
  table_id   = "test_view"

  view {
    query          = file("views/test.sql")
    use_legacy_sql = false
  }
}