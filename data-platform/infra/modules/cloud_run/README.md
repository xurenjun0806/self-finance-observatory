# module: cloud_run

finance-api用のCloud Runサービスを作成するモジュールです。

## 変数

| 変数名 | 説明 |
|---|---|
| `cloud_run_name` | Cloud Run名（デフォルト: `cloud-run-self-finance-observatory`） |
| `project` | GCPプロジェクトID |
| `location` | リージョン |
| `cloud_run_image` | 使用するコンテナイメージのURL |
| `service_account_email` | アタッチするサービスアカウント |
| `bigquery_project` | APIが接続するBigQueryプロジェクトID |
| `auth_api_key` | APIキー（sensitive） |

## コンテナに渡す環境変数

| 変数名 | 値 |
|---|---|
| `BIGQUERY_PROJECT_ID` | `var.bigquery_project` |
| `API_KEY` | `var.auth_api_key` |

## リソース設定

| 項目 | 値 |
|---|---|
| CPU | 1 |
| メモリ | 2Gi |
| 最小インスタンス数 | 0 |
| 最大インスタンス数 | 1 |
