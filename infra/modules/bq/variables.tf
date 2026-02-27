variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "location" {
  description = "BigQueryデータセットのロケーション"
  type        = string
  default     = "asia-northeast1"
}

variable "dataset_ids" {
  description = "BigQueryデータセットIDのリスト"
  type        = list(string)
  default = [ "raw", "cleaned", "mart" ]
}

