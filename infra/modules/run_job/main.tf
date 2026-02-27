resource "google_cloud_run_v2_job" "this" {
  name     = var.job_name
  location = var.location

  template {
    template {
      containers {
        image = var.run_job_image
      }
      service_account = var.service_account_email
    }
  }
}