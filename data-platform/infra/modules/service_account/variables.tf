variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "account_id" {
  description = "サービスアカウントのID（メールアドレスの@より前の部分）"
  type        = string
}

variable "display_name" {
  description = "コンソール上の表示名"
  type        = string
  default     = "Managed by Terraform"
}

variable "project_roles" {
  description = "付与するプロジェクト内のロールのリスト"
  type        = list(string)
  default     = []
}

variable "bigquery_dataset_ids" {
  description = "BigQueryデータセットIDのリスト"
  type        = list(string)
  default     = []
}

variable "bigquery_dataset_roles" {
  description = "付与するBigQueryデータセット内のロールのリスト"
  type        = list(string)
  default     = []
}

variable "storage_bucket_name" {
  description = "GCSバケットの名前"
  type        = string
  default     = ""
}

variable "storage_bucket_roles" {
  description = "付与するストレージバケット内のロールのリスト"
  type        = list(string)
  default     = []
}