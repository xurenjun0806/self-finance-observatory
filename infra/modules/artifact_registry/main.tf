resource "google_artifact_registry_repository" "this" {
  project       = var.project
  repository_id = var.repository_id
  location      = var.localtion
  format        = var.format
  description   = var.description
}