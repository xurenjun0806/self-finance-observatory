output "bq_dataset_ids" {
    value = [for dataset in google_bigquery_dataset.dataset : dataset.dataset_id]
}