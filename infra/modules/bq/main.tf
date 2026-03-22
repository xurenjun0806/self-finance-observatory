resource "google_bigquery_dataset" "dataset" {
  for_each   = toset(var.dataset_ids)
  project    = var.project
  dataset_id = each.key
  location   = var.location
}