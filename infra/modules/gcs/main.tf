resource "google_storage_bucket" "this" {
  project  = var.project
  location = var.region
  name     = var.bucket_name

  public_access_prevention = "enforced"

  #   lifecycle {
  #     prevent_destroy = true
  #   }
}

resource "google_storage_bucket_object" "folder" {
  bucket  = google_storage_bucket.this.name
  name    = "raw/"
  content = " "
}
