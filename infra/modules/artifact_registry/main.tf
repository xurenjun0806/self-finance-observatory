resource "google_artifact_registry_repository" "this" {
  project       = var.project
  repository_id = var.repository_id
  location      = var.location
  format        = var.format
  description   = var.description

  cleanup_policies {
    id     = "keep-latest"
    action = "KEEP"
    most_recent_versions {
      keep_count = 3
    }
  }

  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"
    condition {
      tag_state = "UNTAGGED"
    }
  }
}