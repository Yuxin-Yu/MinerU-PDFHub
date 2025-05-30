# Context7 SaaS - PWA版

Context7のクラウド版実装。Nim言語によるバックエンドとPWA対応のフロントエンドを提供します。

## 特徴

- 🚀 **高速検索**: WebAssemblyによるクライアントサイドでの検索スコアリング
- 🔒 **セキュア**: 組織ごとに分離されたマルチテナント構成
- 📱 **PWA対応**: オフラインでも使用可能なプログレッシブウェブアプリ
- 🎯 **モダンスタック**: htmx + PureCSS + Cash-DOMによる軽量フロントエンド

## 技術スタック

### バックエンド
- Nim 2.0+
- Jester (Webフレームワーク)
- PostgreSQL (データベース)
- Redis (キャッシュ)
- JWT (認証)

### フロントエンド
- htmx (動的UI)
- PureCSS (スタイリング)
- Cash-DOM (軽量DOM操作)
- WebAssembly (Nimロジックの共有)
- Service Worker (PWA/オフライン対応)

## セットアップ

### 開発環境

1. 依存関係のインストール:
```bash
nimble install
```

2. Docker Composeで起動:
```bash
docker-compose up -d
```

3. WebAssemblyのビルド:
```bash
./scripts/build_wasm.sh
```

4. 開発サーバーの起動:
```bash
nimble dev
```

アプリケーションは以下でアクセス可能:
- フロントエンド: http://localhost:3000
- バックエンドAPI: http://localhost:8000

### 本番環境

1. ビルド:
```bash
nimble build
docker build -t context7-saas .
```

2. 環境変数の設定:
```bash
export JWT_SECRET=your-secret-key
export DB_HOST=your-db-host
# その他の環境変数...
```

3. 起動:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## API エンドポイント

### 認証
- `POST /auth/register` - ユーザー登録
- `POST /auth/login` - ログイン

### ライブラリ管理
- `GET /api/libraries` - ライブラリ一覧/検索
- `POST /api/libraries` - ライブラリ登録
- `GET /api/libraries/:id` - ライブラリ詳細取得

## フォルダ構成

```
context7-saas/
├── backend/           # Nimバックエンドサーバー
│   ├── src/          # ソースコード
│   └── tests/        # テスト
├── frontend/         # PWAフロントエンド
│   ├── public/       # 静的ファイル
│   └── src/          # JavaScriptソース
├── shared/           # 共有ロジック（WASM用）
│   └── src/          # Nimソースコード
└── scripts/          # ビルドスクリプト
```

## ライセンス

MIT License