variable "job_name" {
  description = "Cloud Run Jobの名前"
  type        = string
  default     = "dbt-run-job"
}

variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "location" {
  description = "Cloud Run Jobのロケーション"
  type        = string
}

variable "service_account_email" {
  description = "Cloud Run Jobが使用するサービスアカウントのメールアドレス"
  type        = string
}

variable "run_job_image" {
  description = "Cloud Run Jobで使用するコンテナイメージのURL"
  type        = string
}