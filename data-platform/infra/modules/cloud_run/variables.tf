variable "cloud_run_name" {
  description = "Cloud Runの名前"
  type        = string
  default     = "cloud-run-self-finance-observatory"
}

variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "location" {
  description = "Cloud Runのロケーション"
  type        = string
}

variable "service_account_email" {
  description = "Cloud Runが使用するサービスアカウントのメールアドレス"
  type        = string
}

variable "cloud_run_image" {
  description = "Cloud Runで使用するコンテナイメージのURL"
  type        = string
}

variable "bigquery_project" {
  description = "APIが接続するBigQueryのGCPプロジェクトID"
  type        = string
}

variable "auth_api_key" {
  description = "APIキー"
  type        = string
  sensitive = true
}