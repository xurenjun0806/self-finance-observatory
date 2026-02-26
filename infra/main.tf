# GCS作成
module "gcs" {
  source = "./modules/gcs"

  project     = var.project
  region      = var.region
  bucket_name = var.bucket_name
}

