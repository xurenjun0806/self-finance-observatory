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
| `category` | `store_name` をもとに `store_categories.yml` で解決 |

### データフィルタリング

- `current_month_payment` が `NULL` のレコードは除外する
  - 理由: 返済変更（キャンセル・修正）の明細であり、実際の支出ではないため

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

## カテゴリ分類

### 方針

- カテゴリマスターはアプリ側のYAMLファイルで管理する
- BigQueryやClaudeへの依存なし、コストゼロ
- 新しい店舗は手動でYAMLに追記してデプロイ

### ファイル: `src/main/resources/store_categories.yml`

```yaml
categories:
  ﾛｰｿﾝ: コンビニ
  ｾﾌﾞﾝ-ｲﾚﾌﾞﾝ: コンビニ
  ﾌｧﾐﾘｰﾏｰﾄ: コンビニ
  ﾐﾆｽﾄﾂﾌﾟ: コンビニ
  西友: スーパー
  ｲｵﾝｸﾞﾙ-ﾌﾟ: スーパー
  ﾏｲﾊﾞｽｹﾂﾄ: スーパー
  AMAZON.CO.JP: ショッピング
  ﾕﾆｸﾛ: ショッピング
  ﾀﾞｲｿ-: ショッピング
  ﾏﾂﾔ: 食費
  ドミノ・ピザ: 食費
  UBERJP_EATS: 食費
  OPENAI *CHATGPT SUBS利用国US: サブスク
  GITHUB, INC.利用国US: サブスク
  ﾆｭｰｽﾋﾟｯｸｽ: サブスク
  ﾓﾊﾞｲﾙﾊﾟｽﾓﾁﾔ-ｼﾞ: 交通
  Ｓｕｉｃａ（携帯決済）: 交通
  ﾄｳｷﾖｳﾒﾄﾛﾃﾂﾄﾞｳﾃｲｷｹ: 交通
  ｽｷﾞﾔﾂｷﾖｸ: 薬局
  ﾔｽｲﾔﾂｷﾖｸﾎﾝﾃﾝ: 薬局
```

### カテゴリ解決ロジック

```
store_name を store_categories.yml と前方一致で照合
  → 一致した場合: 該当カテゴリを返す
  → 一致しない場合: category = "未分類" で返す
```

前方一致にすることで `ﾛｰｿﾝ` が `ﾛｰｿﾝ　京都店` などにもマッチする。

## 認証

- Spring Security のデフォルト認証を使用（開発中）
- 将来的にAPIキー認証に切り替え予定

## 今後の実装ロードマップ

1. **BigQuery連携** — `ExpenseRepository` の実装
2. **カテゴリ分類** — `store_categories.yml` + `CategoryResolver` の実装
3. **キャッシュ設定** — `CacheConfig` + `@Cacheable` の追加
4. **認証** — APIキー認証への切り替え
