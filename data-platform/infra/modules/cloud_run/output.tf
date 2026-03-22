output "cloud_run_name" {
  value       = google_cloud_run_service.this.name
  description = "Cloud Runの名前"
}

output "cloud_run_id" {
  value       = google_cloud_run_service.this.id
  description = "Cloud RunのリソースID"
}
