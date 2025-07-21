# 📚 ヘルプ・ガイド

プロジェクト固有のカスタムコマンドと使用方法を説明します。

**使用法**: `/help [command]`

---

## 🚀 利用可能なコマンド一覧

### 🤖 自律開発システム
```bash
/auto <action> [options]    # 自律開発システムの制御
```
完全自律でプロジェクトを継続的に発展させるシステム。PR完了監視、ISSUE検索・実行、自動生成を無限ループで実行。

**主要アクション**:
- `start` - 自律実行開始
- `status` - 現在状況確認  
- `cycle` - 手動サイクル実行
- `stop` - システム停止
- `config` - 設定管理
- `logs` - ログ・メトリクス確認

### 🎼 タスク実行システム
```bash
/orchestrate <task_description>    # 複雑なタスクの分解・並列実行
/task <task_description>           # 単一タスクの効率的実行
```

**使い分け指針**:
- **`/task`**: 1-4時間の単純〜中程度のタスク
- **`/orchestrate`**: 4時間以上の複雑なタスク、複数コンポーネント関連

### 🔍 プロジェクト分析
```bash
/analyze [scope] [options]    # プロジェクト分析と改善提案
```

**分析スコープ**:
- `all` - 包括的分析（デフォルト）
- `code` - コード品質特化
- `performance` - パフォーマンス特化
- `security` - セキュリティ特化
- `dependencies` - 依存関係分析
- `tests` - テスト分析

---

## 📋 引数指定時の詳細ヘルプ

### `/help auto`
```bash
# 自律開発システム詳細ヘルプ

## 基本使用法
/auto start                    # 基本設定で自律実行開始
/auto start --interval=15      # 15分間隔で実行
/auto start --dry-run          # シミュレーション実行
/auto status --detailed        # 詳細状況表示
/auto cycle --issue-id=123     # 特定ISSUE強制実行
/auto stop --force            # 即座停止

## 設定管理
/auto config show                           # 全設定表示
/auto config set cycle_interval_minutes 20 # サイクル間隔変更
/auto config set max_concurrent_prs 5       # 同時PR数制限

## ログ・監視
/auto logs --last=24h          # 過去24時間のログ
/auto logs --filter=error      # エラーのみ表示
/auto logs --metrics           # パフォーマンス指標

## 自律実行フロー
1. PR監視・完了処理 → 2. ISSUE検索・選択 → 3. オーケストレーター実行
4. PR作成・CI監視 → 1に戻る（無限ループ）

## 主要設定項目
- cycle_interval_minutes: サイクル実行間隔（デフォルト: 30分）
- max_concurrent_prs: 同時実行可能PR数（デフォルト: 3）
- auto_merge_enabled: 自動マージ有効化（デフォルト: false）
- issue_auto_creation: ISSUE自動生成（デフォルト: true）
```

### `/help orchestrate`
```bash
# オーケストレーター詳細ヘルプ

## 適用場面
- 複雑な機能開発（4時間以上）
- 複数コンポーネントにまたがる変更
- 新しいアーキテクチャの実装
- 大規模リファクタリング

## 実行フロー
1. 要件分析・依存関係特定
2. タスクを独立可能な粒度に分解
3. container-use環境で並列実行
4. 品質チェック・統合処理
5. Pull Request作成

## 使用例
/orchestrate "ユーザー認証システムを実装"
→ 自動分解: 認証API + フロントエンド + テスト + ドキュメント

/orchestrate "決済システムのパフォーマンス最適化"
→ 自動分解: DB最適化 + キャッシュ実装 + API改善 + 負荷テスト

## 並列実行の利点
- 実行時間の大幅短縮（60-80%削減）
- 各タスクの独立性保証
- 並行作業による効率向上
- 失敗時の影響局所化
```

### `/help task`
```bash
# タスク実行システム詳細ヘルプ

## 適用場面
- 単純なバグ修正（30分-2時間）
- 小さな機能追加（1-4時間）
- ドキュメント更新
- テスト追加
- 軽微なリファクタリング

## 実行パターン自動選択
- **直接実行**: 1-3ファイル修正、明確な作業内容
- **Task Tools**: 複数コンポーネント、調査・分析必要
- **Container-Use**: 新機能・大きな変更、環境構築必要

## タスク種別例
/task "ログイン画面のバリデーションエラーを修正"        # バグ修正
/task "ユーザープロファイル編集機能を追加"              # 新機能
/task "README にAPI使用例を追加"                      # ドキュメント
/task "UserService クラスをリファクタリング"           # リファクタリング

## 自動エスカレーション
複雑度が閾値を超える場合、自動的に/orchestrateを推奨:
- 5ファイル以上に影響
- 推定4時間以上
- 外部システム連携必要
```

### `/help analyze`
```bash
# プロジェクト分析詳細ヘルプ

## 分析タイプ
/analyze              # 全体的な健全性チェック
/analyze code         # コード品質・アーキテクチャ分析  
/analyze performance  # パフォーマンス・リソース分析
/analyze security     # セキュリティ・脆弱性分析
/analyze dependencies # 依存関係・ライブラリ分析
/analyze tests        # テストカバレッジ・品質分析

## 出力内容
- プロジェクト健全性スコア（A-F評価）
- 詳細分析結果（問題点・改善点）
- 優先度付き改善提案
- 実行可能なタスクリスト
- 自動生成可能なISSUE

## 活用例
1. 定期的なプロジェクト健康診断
2. 技術的負債の可視化
3. パフォーマンス問題の特定
4. セキュリティリスク評価
5. 改善タスクの自動生成

## 継続監視
分析結果から重要指標を抽出し、継続的な監視体制を構築:
- 週次: テストカバレッジ、ビルド時間
- 月次: 依存関係、セキュリティスキャン  
- 四半期: アーキテクチャ健全性、技術的負債
```

---

## 🔄 ワークフロー推奨パターン

### 🎯 通常の開発フロー
```bash
# 1. プロジェクト分析で改善点特定
/analyze

# 2. 特定された問題に対応
/task "分析で特定された軽微な問題を修正"
/orchestrate "分析で特定された複雑な改善を実装"

# 3. 自律システムで継続的改善
/auto start

# 4. 定期的な監視
/auto status
/analyze performance
```

### 🚀 新機能開発フロー
```bash
# 1. 要件の複雑度に応じて選択
/task "シンプルな新機能を追加"           # 1-4時間程度
/orchestrate "複雑な新機能を実装"        # 4時間以上

# 2. 開発完了後の分析
/analyze code                           # 品質確認
/analyze performance                    # パフォーマンス影響確認

# 3. 必要に応じて最適化
/task "分析結果に基づく最適化を実行"
```

### 🔧 メンテナンス・改善フロー
```bash
# 1. 包括的現状分析
/analyze

# 2. 優先度に基づく段階的改善
/task "高優先度の軽微な改善を実行"
/orchestrate "中優先度の複雑な改善を実装"

# 3. 自律システムで継続的メンテナンス
/auto start --interval=60               # 1時間間隔で実行

# 4. 効果測定
/analyze --compare=previous             # 改善効果確認
```

---

## ⚙️ 設定とカスタマイゼーション

### プロジェクト固有設定
```yaml
# .claude/project-config.yaml
project_preferences:
  default_task_type: "task"              # task | orchestrate
  auto_analysis_frequency: "weekly"      # daily | weekly | monthly  
  preferred_test_framework: "vitest"     # jest | vitest | mocha
  code_style: "typescript-strict"        # typescript | javascript
  
quality_standards:
  min_test_coverage: 80
  max_code_complexity: 15
  security_level: "high"
  performance_budget: "strict"

automation_level:
  auto_merge_enabled: false
  auto_issue_creation: true
  auto_dependency_updates: true
  auto_security_patches: true
```

### 個人設定
```yaml
# ~/.claude/personal-config.yaml
personal_preferences:
  notification_level: "important"        # all | important | critical
  default_work_hours: "09:00-18:00"
  timezone: "Asia/Tokyo"
  
command_aliases:
  "/quick": "/task"
  "/complex": "/orchestrate"  
  "/check": "/analyze"
  "/go": "/auto start"
```

---

## 🚨 トラブルシューティング

### よくある問題と解決法

#### コマンドが認識されない
```bash
# 確認事項
1. ファイルが .claude/commands/ に配置されているか
2. ファイル名が正しい（拡張子.md必須）
3. Markdown形式で記述されているか

# 解決法
ls .claude/commands/        # ファイル一覧確認
/help                      # コマンド一覧再確認
```

#### 自律システムが動作しない
```bash
# デバッグ手順
/auto status               # 現在状態確認
/auto logs --filter=error  # エラーログ確認
/auto config show          # 設定確認

# 一般的な解決法
/auto stop --force         # 強制停止
/auto start --dry-run      # シミュレーション実行
```

#### 分析結果が期待と違う
```bash
# 分析精度向上
/analyze --deep            # 詳細分析実行
/analyze code --verbose    # 詳細コード分析

# 設定調整
/analyze config show       # 分析設定確認
```

### サポートリソース
- **GitHub Issues**: バグ報告・機能要求
- **Project Documentation**: 詳細ドキュメント
- **Community Wiki**: ベストプラクティス共有

---

## 📈 効果的な使用のコツ

### 1. 適切なコマンド選択
- **小さなタスク**: `/task` - 迅速な実行
- **大きなタスク**: `/orchestrate` - 品質重視
- **継続的改善**: `/auto` - 長期的発展
- **現状把握**: `/analyze` - データドリブン判断

### 2. 段階的アプローチ
```bash
# Step 1: 現状理解
/analyze

# Step 2: 即座対応
/task "緊急性の高い問題を修正"

# Step 3: 計画的改善  
/orchestrate "中長期的な改善を実装"

# Step 4: 自動化
/auto start
```

### 3. 監視と改善
```bash
# 定期的な健全性チェック
/auto status
/analyze --compare=last-month

# パフォーマンス最適化
/analyze performance
/task "特定されたボトルネックを解消"
```

このヘルプシステムにより、各コマンドの適切な使用方法と効果的なワークフローが習得できます。