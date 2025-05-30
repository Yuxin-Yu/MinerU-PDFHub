# ライブラリドキュメント作成ガイド

## 基本構造

context7localに登録するMarkdownドキュメントは、以下の構造で作成することを推奨します：

```markdown
# [ライブラリ名] v[バージョン番号]

## 概要
[このライブラリが何をするものか、1-2段落で説明]

## インストール
[インストール方法を具体的に記載]

## クイックスタート
[最も基本的な使用例を示す]

## 主要機能

### [機能1]
[説明とコード例]

### [機能2]
[説明とコード例]

## API リファレンス
[主要なAPI/関数/クラスの詳細]

## 使用例
[実践的なコード例]

## 設定
[設定ファイルや環境変数]

## トラブルシューティング
[よくある問題と解決方法]

## 制限事項
[既知の制限や注意点]
```

## 作成のベストプラクティス

### 1. 明確な概要を最初に
- ライブラリの目的を明確に説明
- どんな問題を解決するのか記載
- 主な機能を箇条書きで

### 2. コード例を豊富に
- コピペで動くコード例を提供
- 言語を明示（```python、```javascript など）
- エラーハンドリングも含める

### 3. 実践的な情報を含める
- 実際の使用シナリオ
- パフォーマンスのヒント
- セキュリティの考慮事項

### 4. 社内固有の情報を明記
- 内部URLやエンドポイント
- 社内認証方法
- 担当チームや連絡先

## テンプレート例

### REST APIの場合

```markdown
# [API名] v[バージョン]

## 概要
[APIの目的と機能の説明]

## ベースURL
```
https://internal-api.company.local/v1
```

## 認証
```
Authorization: Bearer <token>
```

## エンドポイント

### GET /resources
[説明]

**パラメータ:**
- `param1` (string, required): 説明
- `param2` (integer, optional): 説明

**レスポンス例:**
```json
{
  "data": [],
  "total": 0
}
```

### POST /resources
[説明]

**リクエストボディ:**
```json
{
  "field1": "value",
  "field2": 123
}
```

**レスポンス例:**
```json
{
  "id": "12345",
  "created_at": "2024-01-01T00:00:00Z"
}
```

## エラーコード
| コード | 説明 |
|--------|------|
| 400 | Bad Request |
| 401 | Unauthorized |
| 404 | Not Found |

## 使用例

### Python
```python
import requests

headers = {'Authorization': 'Bearer token'}
response = requests.get('https://internal-api.company.local/v1/resources', headers=headers)
```

### cURL
```bash
curl -H "Authorization: Bearer token" https://internal-api.company.local/v1/resources
```
```

### ライブラリ/SDKの場合

```markdown
# [ライブラリ名] v[バージョン]

## 概要
[ライブラリの説明]

## インストール

### NPM
```bash
npm install @company/library-name
```

### Python
```bash
pip install company-library-name
```

## 基本的な使用方法

### 初期化
```javascript
const Library = require('@company/library-name');

const client = new Library({
  apiKey: process.env.API_KEY,
  environment: 'production'
});
```

## 主要なクラス/関数

### Class: Client
メインのクライアントクラス

#### コンストラクタ
```javascript
new Client(options)
```

**パラメータ:**
- `options.apiKey` (string): APIキー
- `options.environment` (string): 環境（development/production）

#### メソッド

##### async getData(id)
データを取得

```javascript
const data = await client.getData('12345');
console.log(data);
```

##### async createData(params)
新規データ作成

```javascript
const newData = await client.createData({
  name: 'テストデータ',
  type: 'sample'
});
```

## 高度な使用例

### バッチ処理
```javascript
const results = await client.batchProcess([
  { action: 'create', data: {...} },
  { action: 'update', id: '123', data: {...} }
]);
```

### エラーハンドリング
```javascript
try {
  const data = await client.getData('12345');
} catch (error) {
  if (error.code === 'NOT_FOUND') {
    console.log('データが見つかりません');
  } else {
    console.error('エラー:', error);
  }
}
```

## 設定オプション

| オプション | タイプ | デフォルト | 説明 |
|-----------|--------|------------|------|
| apiKey | string | - | APIキー（必須） |
| timeout | number | 30000 | タイムアウト（ミリ秒） |
| retries | number | 3 | リトライ回数 |

## 環境変数
- `LIBRARY_API_KEY`: APIキー
- `LIBRARY_ENV`: 環境（development/production）
- `LIBRARY_LOG_LEVEL`: ログレベル（debug/info/warn/error）
```

## 既存ドキュメントからの変換

### 1. 社内Wikiから
社内Wikiの内容をコピーして、Markdown形式に整形します：
- HTMLタグを除去
- 見出しを`#`記号に変換
- コードブロックを` ``` `で囲む
- テーブルをMarkdown形式に変換

### 2. README.mdから
既存のREADME.mdがある場合は、そのまま使用可能です。
必要に応じて社内固有の情報を追加してください。

### 3. APIドキュメントから
- Swagger/OpenAPIからMarkdownに変換
- Postmanコレクションから抽出
- 社内ツールのヘルプから作成

## ドキュメント作成のヒント

### LLMが理解しやすい形式にする
1. **具体的なコード例**: 実際に動くコードを提供
2. **明確なパラメータ説明**: 型、必須/オプション、デフォルト値
3. **エラーケース**: どんなエラーが起きるか、対処法
4. **実践的なユースケース**: 実際の業務での使用例

### 検索性を高める
1. **キーワードを含める**: ライブラリ名、機能名、技術名
2. **日本語と英語を併記**: 検索しやすくする
3. **タグや分類を明記**: データベース、認証、ユーティリティなど

### メンテナンスしやすくする
1. **バージョン情報を明記**: 変更履歴も含める
2. **更新日時を記載**: 最終更新日
3. **担当者/チーム情報**: 問い合わせ先

## 自動生成ツール

### TypeScriptからドキュメント生成
```bash
# TypeDocを使用
npx typedoc --out docs src/index.ts --plugin typedoc-plugin-markdown
```

### Pythonからドキュメント生成
```bash
# Sphinxを使用
sphinx-apidoc -o docs/source mypackage/
sphinx-build -b markdown docs/source docs/markdown
```

### OpenAPIからMarkdown生成
```bash
# openapi-to-markdownを使用
npx openapi-to-markdown -i openapi.yaml -o api-docs.md
```

## チェックリスト

ドキュメントを登録する前に確認：

- [ ] ライブラリ名とバージョンが明記されている
- [ ] 概要でライブラリの目的が分かる
- [ ] インストール方法が具体的
- [ ] 基本的な使用例がある
- [ ] 主要なAPI/関数が説明されている
- [ ] エラーハンドリングの例がある
- [ ] 社内固有の設定（URL、認証など）が含まれている
- [ ] 問い合わせ先が記載されている