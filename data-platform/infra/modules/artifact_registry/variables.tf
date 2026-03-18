variable "project" {
  description = "GCPのプロジェクトID"
  type        = string
}

variable "location" {
  description = "Artifact Registryのロケーション"
  type        = string
}

variable "repository_id" {
  description = "Artifact RegistryのリポジトリID"
  type        = string
}

variable "format" {
  description = "Artifact Registryのフォーマット"
  type        = string
  default     = "DOCKER"
}

variable "description" {
  description = "Artifact Registryの説明"
  type        = string
  default     = ""
}