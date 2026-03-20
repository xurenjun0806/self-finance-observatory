# Finance API アーキテクチャ設計

## 全体構成

```
[楽天カード明細CSV]
        ↓
  [GCS (Raw)]
        ↓
  [dbt-run-job]  ← Cloud Run Job で定期実行
        ↓
  [BigQuery]
        ↓
  [finance-api]  ← Spring Boot
        ↓
  [AIエージェント / クライアント]
```

## コンポーネント構成

```
finance-api/
├── controller/       # HTTPリクエストの受付（openapi-generatorで生成したインターフェースを実装）
├── service/          # ビジネスロジック・キャッシュ制御
├── repository/       # BigQueryへのクエリ
└── config/           # Spring設定（Security・Cache）
```

### 各レイヤーの責務

| レイヤー | クラス例 | 責務 |
|---|---|---|
| Controller | `ExpenseController` | リクエスト受付・バリデーション・レスポンス返却 |
| Service | `ExpenseService` | ビジネスロジック・キャッシュ制御 |
| Repository | `ExpenseRepository` | BigQueryへのクエリ実行 |
| Config | `SecurityConfig`, `CacheConfig` | Spring設定 |

## BigQueryスキーマ

### テーブル: `cleaned.rakuten_usage_details`

| カラム名 | 型 | 説明 |
|---|---|---|
| `payment_month` | DATE | 支払月（YYYY-MM-01形式） |
| `used_at` | DATE | 利用日 |
| `store_name` | STRING | 店舗名 |
| `card_holder` | STRING | カード保有者 |
| `payment_method` | STRING | 支払方法 |
| `amount` | INT64 | 利用金額（円） |
| `fee` | INT64 | 手数料（円） |
| `total_amount` | INT64 | 合計金額（円） |
| `current_month_payment` | INT64 | 当月支払額（円） |

### APIレスポンスとのマッピング

| APIフィールド | BigQueryカラム |
|---|---|
| `date` | `used_at` |
| `description` | `store_name` |
| `amount` | `amount` |
| `category` | ※未実装（将来的に追加予定） |

## キャッシュ戦略

BigQueryはクエリ単位で課金されるため、キャッシュでコストを削減する。

### 実装方針

- ライブラリ: **Caffeine**（インメモリキャッシュ）
- アノテーション: `@Cacheable` をServiceレイヤーに付与

### TTL設定

| データ種別 | TTL | 理由 |
|---|---|---|
| 過去月のデータ | 無期限 | dbt実行後に変わらない |
| 当月のデータ | 1時間 | dbt-run-jobの実行頻度に合わせる |

### キャッシュキー

```
expenses:{year}:{month}        # 支出一覧
expenses:summary:{year}:{month} # カテゴリ別集計
```

## 認証

- Spring Security のデフォルト認証を使用（開発中）
- 将来的にAPIキー認証に切り替え予定

## 今後の実装ロードマップ

1. **BigQuery連携** — `ExpenseRepository` の実装
2. **キャッシュ設定** — `CacheConfig` + `@Cacheable` の追加
3. **認証** — APIキー認証への切り替え
4. **カテゴリ分類** — 店舗名からカテゴリを自動分類
