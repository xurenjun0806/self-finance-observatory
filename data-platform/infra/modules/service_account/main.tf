resource "google_service_account" "this" {
  project      = var.project
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_project_iam_member" "this" {
  for_each = toset(var.project_roles)
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.this.email}"
}

resource "google_bigquery_dataset_iam_member" "this" {
  for_each = {
    for pair in setproduct(var.bigquery_dataset_ids, var.bigquery_dataset_roles) :
    "${pair[0]}/${pair[1]}" => { dataset_id = pair[0], role = pair[1] }
  }
  dataset_id = each.value.dataset_id
  role       = each.value.role
  member     = "serviceAccount:${google_service_account.this.email}"
}

resource "google_storage_bucket_iam_member" "this" {
  for_each = toset(var.storage_bucket_roles)
  bucket   = var.storage_bucket_name
  role     = each.value
  member   = "serviceAccount:${google_service_account.this.email}"
}