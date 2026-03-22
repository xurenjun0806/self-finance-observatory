variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "region" {
  description = "GCPリージョン"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "GCPゾーン"
  type        = string
  default     = "asia-northeast1-c"
}

variable "bucket_name" {
  description = "GCSバケットの名前"
  type        = string
  default     = "self-finance-observatory-data"
}

variable "auth_api_key" {
  description = "API用の認証キー"
  type        = string
}