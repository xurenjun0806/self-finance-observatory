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
  description = "付与するロールのリスト"
  type        = list(string)
  default     = []
}