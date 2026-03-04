resource "google_cloud_run_v2_job" "this" {
  name     = var.job_name
  location = var.location

  template {
    template {
      containers {
        image = var.run_job_image
        env {
          name  = "GCS_BUCKET_URL"
          value = var.gcs_bucket_url
        }
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
      service_account = var.service_account_email
    }
  }
}