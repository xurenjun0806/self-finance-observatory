# dbt_run

self-finance-observatoryのdbtプロジェクトです。

## 環境変数

| 変数名 | 説明 | 例 |
|---|---|---|
| `GCS_BUCKET_URL` | 外部テーブルが参照するGCSバケットURL | `gs://your-bucket-name` |

## ローカル開発での設定方法

### 1. `.env` ファイルを作成

```bash
cp .env.example .env
```

`.env` を編集してバケットURLを設定します。

```
GCS_BUCKET_URL=gs://your-bucket-name
```

### 2. 環境変数を読み込む

```bash
source .env
```

または、毎回自動で読み込みたい場合は `direnv` を使います。

```bash
# .envrc を作成
echo "dotenv" > .envrc

# direnv に許可を与える（初回のみ）
direnv allow
```

以降はディレクトリに入るだけで自動的に環境変数が読み込まれます。

## 外部テーブルの作成・更新

外部テーブルの定義は `models/sources/` 以下のYAMLファイルで管理しています。
定義を変更した場合は以下のコマンドで反映します。

```bash
# 初回 or 強制再作成
dbt run-operation stage_external_sources --vars 'ext_full_refresh: true'

# 通常の更新
dbt run-operation stage_external_sources
```

## 通常の実行

```bash
dbt run
dbt test
```
