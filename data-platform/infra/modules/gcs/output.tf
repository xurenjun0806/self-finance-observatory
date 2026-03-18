output "bucket_name" {
  value = google_storage_bucket.this.name
}

output "bucket_url" {
  value = "gs://${google_storage_bucket.this.name}"
}

output "folder_name" {
  value = google_storage_bucket_object.folder.name
}

output "folder_url" {
  value = "gs://${google_storage_bucket.this.name}/${google_storage_bucket_object.folder.name}"
}