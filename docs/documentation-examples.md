# ドキュメント作成の実例

## 例1: シンプルなユーティリティライブラリ

```markdown
# 社内共通ユーティリティ v1.2.0

## 概要
社内システムで共通的に使用されるユーティリティ関数群。
日付処理、文字列変換、バリデーション機能を提供。

## インストール
```bash
npm install @company/common-utils
```

## 使用方法

### 日付処理
```javascript
const { dateUtils } = require('@company/common-utils');

// 営業日計算
const nextBusinessDay = dateUtils.addBusinessDays(new Date(), 3);

// 社内カレンダー対応
const isHoliday = dateUtils.isCompanyHoliday('2024-05-01');
```

### 文字列処理
```javascript
const { stringUtils } = require('@company/common-utils');

// 社員番号フォーマット
const formatted = stringUtils.formatEmployeeId('12345'); // => 'EMP-012345'

// 部署コード変換
const deptName = stringUtils.getDepartmentName('DEV'); // => '開発部'
```

## API一覧
- `dateUtils.addBusinessDays(date, days)` - 営業日加算
- `dateUtils.isCompanyHoliday(date)` - 社内休日判定
- `stringUtils.formatEmployeeId(id)` - 社員番号整形
- `stringUtils.getDepartmentName(code)` - 部署名取得
```

## 例2: 既存のSwagger/OpenAPIから変換

```markdown
# 在庫管理API v2.0.0

## 概要
社内在庫管理システムのREST API。商品在庫の照会、更新、移動処理を提供。

## ベースURL
```
https://inventory.company.local/api/v2
```

## 認証
全エンドポイントで社内SSOトークンが必要：
```
Authorization: Bearer <sso_token>
X-Department-Code: <部署コード>
```

## エンドポイント

### 在庫照会

#### GET /inventory/{product_code}
指定商品の在庫情報を取得

**パラメータ:**
- `product_code` (path, string, required): 商品コード
- `warehouse` (query, string, optional): 倉庫コード（省略時は全倉庫）

**レスポンス例:**
```json
{
  "product_code": "PRD-12345",
  "product_name": "サンプル商品",
  "total_quantity": 150,
  "warehouses": [
    {
      "warehouse_code": "WH-01",
      "warehouse_name": "東京倉庫",
      "quantity": 100,
      "location": "A-1-1"
    },
    {
      "warehouse_code": "WH-02", 
      "warehouse_name": "大阪倉庫",
      "quantity": 50,
      "location": "B-2-3"
    }
  ],
  "last_updated": "2024-05-30T10:30:00+09:00"
}
```

### 在庫更新

#### PUT /inventory/{product_code}
在庫数を更新（棚卸し時など）

**リクエストボディ:**
```json
{
  "warehouse_code": "WH-01",
  "quantity": 95,
  "reason": "棚卸し調整",
  "adjusted_by": "EMP-12345"
}
```

**レスポンス例:**
```json
{
  "success": true,
  "transaction_id": "TRX-20240530-001",
  "previous_quantity": 100,
  "new_quantity": 95,
  "difference": -5
}
```

## エラーコード
| コード | 説明 | 対処法 |
|--------|------|--------|
| INV-001 | 商品コードが存在しない | 商品マスタを確認 |
| INV-002 | 在庫数が不足 | 在庫数を確認して再度実行 |
| INV-003 | 倉庫コードが無効 | 有効な倉庫コードを指定 |
| INV-004 | 権限不足 | 部署権限を確認 |

## 使用例

### Python
```python
import requests
from company_auth import get_sso_token

# 認証トークン取得
token = get_sso_token()
headers = {
    'Authorization': f'Bearer {token}',
    'X-Department-Code': 'LOG'  # 物流部
}

# 在庫照会
response = requests.get(
    'https://inventory.company.local/api/v2/inventory/PRD-12345',
    headers=headers
)
inventory = response.json()
print(f"総在庫数: {inventory['total_quantity']}")
```

## 担当
- システム: 物流システム部
- 連絡先: logistics-system@company.local
- 内線: 1234
```

## 例3: 社内フレームワークのドキュメント

```markdown
# Company Web Framework v3.5.0

## 概要
社内Webアプリケーション開発用フレームワーク。
社内認証、ロギング、エラーハンドリングを標準装備。

## セットアップ

### プロジェクト作成
```bash
npx @company/create-app my-app
cd my-app
npm install
npm run dev
```

## プロジェクト構造
```
my-app/
├── src/
│   ├── controllers/    # コントローラー
│   ├── models/        # データモデル
│   ├── views/         # ビューテンプレート
│   └── middleware/    # ミドルウェア
├── config/            # 設定ファイル
├── tests/            # テスト
└── package.json
```

## 基本的な使い方

### コントローラー作成
```javascript
// src/controllers/UserController.js
const { Controller, requireAuth } = require('@company/web-framework');

class UserController extends Controller {
  @requireAuth(['admin', 'manager'])
  async index(req, res) {
    const users = await this.model('User').findAll({
      department: req.user.department
    });
    
    return this.render('users/index', { users });
  }
  
  async create(req, res) {
    try {
      const user = await this.model('User').create(req.body);
      return this.success('ユーザーを作成しました', { user });
    } catch (error) {
      return this.error('作成に失敗しました', error);
    }
  }
}

module.exports = UserController;
```

### モデル定義
```javascript
// src/models/User.js
const { Model, validators } = require('@company/web-framework');

class User extends Model {
  static tableName = 'users';
  
  static schema = {
    employee_id: {
      type: 'string',
      required: true,
      validate: validators.employeeId()
    },
    email: {
      type: 'string',
      required: true,
      validate: validators.companyEmail()
    },
    department: {
      type: 'string',
      required: true,
      validate: validators.departmentCode()
    }
  };
  
  static relations = {
    department: {
      type: 'belongsTo',
      model: 'Department',
      foreignKey: 'department_code'
    }
  };
}

module.exports = User;
```

## 組み込み機能

### 社内認証
自動的に社内SSOと連携：
```javascript
// config/auth.js
module.exports = {
  sso: {
    url: 'https://sso.company.local',
    clientId: process.env.SSO_CLIENT_ID,
    clientSecret: process.env.SSO_CLIENT_SECRET
  },
  session: {
    secret: process.env.SESSION_SECRET,
    timeout: 3600
  }
};
```

### ロギング
全リクエストを自動記録：
```javascript
// ログは自動的に以下の形式で記録
{
  "timestamp": "2024-05-30T10:00:00+09:00",
  "request_id": "req-12345",
  "user_id": "EMP-12345",
  "method": "POST",
  "path": "/api/users",
  "status": 201,
  "duration": 45
}
```

### エラーハンドリング
```javascript
// 自動的にエラーをキャッチして適切なレスポンスを返す
throw new ValidationError('入力が無効です', {
  field: 'email',
  value: 'invalid-email'
});
// => 400 Bad Request with details
```

## 設定

### 環境変数
```bash
# .env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgres://user:pass@db.company.local/myapp
REDIS_URL=redis://cache.company.local:6379
SSO_CLIENT_ID=myapp-client
SSO_CLIENT_SECRET=secret
SESSION_SECRET=random-secret
LOG_LEVEL=info
```

## デプロイ

### 社内PaaS
```bash
# Dockerfile は自動生成済み
company-deploy --app=my-app --env=production
```

## よくある質問

**Q: 外部APIとの連携は？**
A: `this.httpClient` を使用してください。自動的にプロキシ設定されます。

**Q: ファイルアップロードは？**
A: `@company/file-handler` ミドルウェアを使用してください。

## サポート
- Wiki: https://wiki.company.local/web-framework
- Slack: #web-framework-support
- チーム: プラットフォームチーム
```

## 例4: 簡潔な内部ツールのドキュメント

```markdown
# ログ解析ツール v1.0.0

## 概要
アプリケーションログから異常を検出して通知する内部ツール。

## 使い方
```bash
# 基本的な使用
log-analyzer --file /var/log/app.log --threshold 100

# リアルタイム監視
log-analyzer --tail /var/log/app.log --alert-slack #alerts
```

## オプション
- `--file, -f`: ログファイルパス
- `--tail, -t`: リアルタイム監視
- `--threshold`: エラー閾値（デフォルト: 50）
- `--alert-slack`: Slack通知先
- `--pattern`: 検出パターン（正規表現）

## 検出パターン
デフォルトで以下を検出：
- `ERROR`, `FATAL`
- `OutOfMemory`
- `Connection refused`
- `Timeout`
- 5xx系HTTPステータス

## 設定ファイル
```yaml
# ~/.log-analyzer.yml
patterns:
  - name: "DB接続エラー"
    regex: "Database connection failed"
    severity: "high"
    
thresholds:
  error: 50
  warning: 100
  
notifications:
  slack:
    webhook: "https://hooks.slack.com/..."
    channel: "#alerts"
```

## 担当: SREチーム
```