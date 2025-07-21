# 🤖 自律開発システム - 統合実行コマンド

完全自律でプロジェクトを継続的に発展させるシステムの統合制御インターフェース。

---

## 🚀 クイックスタート

```bash
# 自律システム起動
/autonomous start

# 現在状況確認  
/autonomous status

# 手動でサイクル実行
/autonomous cycle

# システム停止
/autonomous stop
```

---

## 📋 コマンド詳細仕様

### `/autonomous start [options]`
自律実行システムを開始

```text
AUTONOMOUS_START_EXECUTION:

前提条件チェック:
  1. GitHub API アクセス確認
  2. プロジェクトリポジトリ存在確認
  3. 必要なCI/CDパイプライン設定確認
  4. 実行権限確認

初期化シーケンス:
  1. 設定ファイル読み込み (.claude/autonomous-config.yaml)
  2. 実行状態ファイル初期化 (.claude/autonomous-state.json)
  3. ログシステム設定
  4. GitHub API 認証確認
  5. 初回プロジェクト分析実行

開始オプション:
  --interval=30     # サイクル間隔（分）
  --max-wait=2h     # CI最大待機時間
  --dry-run         # 実際の変更なしでシミュレーション
  --verbose         # 詳細ログ出力
  --config=path     # カスタム設定ファイル指定

実行確認メッセージ:
  🤖 自律開発システム開始
  
  設定:
  - サイクル間隔: 30分
  - 最大並列PR: 3
  - CI最大待機: 2時間
  - ISSUE自動生成: 有効
  
  初回サイクル開始まで: 2分
  
  制御コマンド:
  - 停止: /autonomous stop
  - 状況確認: /autonomous status
  - 設定変更: /autonomous config
```

### `/autonomous status [options]`
現在の実行状況を表示

```text
AUTONOMOUS_STATUS_DISPLAY:

実行状態情報:
  🔄 実行状態: RUNNING | PAUSED | STOPPED | ERROR
  ⏱️ 稼働時間: 2日 14時間 23分
  🔄 現在サイクル: #47
  📈 完了したISSUE: 23個
  🔧 作成したPR: 21個
  ✅ マージ済みPR: 19個

現在の活動:
  📋 実行中ISSUE: "#456 - API認証システム改善"
  🏗️ 作業ブランチ: "feat/auto-456-auth-improvements"  
  ⏳ 開始からの経過: 1時間 15分
  📊 進捗: オーケストレーター実行中 - ステップ 2/4

監視中PR:
  📝 PR #123: "feat: ユーザープロファイル更新機能"
    - CI状態: ✅ 全チェック完了
    - レビュー: 👀 レビュー待ち (12時間経過)
    - マージ準備: 🟡 レビュー承認待ち
    
  📝 PR #124: "fix: パフォーマンス最適化"  
    - CI状態: ⚠️ テスト実行中 (15分経過)
    - レビュー: ⏳ レビュー未要求
    - 予想完了: 10分後

次回予定:
  🔍 次ISSUE検索: 45分後
  📊 週次レポート生成: 2日後
  🧹 システムメンテナンス: 6日後

パフォーマンス:
  📈 今週完了ISSUE: 12個
  ⚡ 平均サイクル時間: 3.2時間
  🎯 成功率: 94%
  🚀 生産性スコア: A-

状況確認オプション:
  --detailed        # 詳細情報表示
  --logs           # 最近のログ表示
  --metrics        # メトリクス詳細
  --history        # 履歴表示
```

### `/autonomous cycle [options]`
手動でサイクルを実行

```text
AUTONOMOUS_CYCLE_EXECUTION:

サイクル実行フロー:
  1. 🔍 現在のPR状況確認
     - 監視中PR一覧取得
     - CI/CDステータスチェック
     - マージ可能性確認
     
  2. ✅ 完了PR処理
     - マージ済みPRクリーンアップ
     - 関連ISSUEクローズ
     - ブランチ削除
     
  3. 🎯 次ISSUE検索
     - GitHub API経由でISSUE検索
     - 実行可能性スコア計算
     - 最適ISSUE選択
     
  4. 🏗️ ISSUE実行 OR 生成
     - 選択されたISSUE → オーケストレーター実行
     - ISSUE不在 → プロジェクト分析 → 新ISSUE生成 → 実行
     
  5. 📊 状態更新
     - 実行状態ファイル更新
     - メトリクス記録
     - 次回サイクル時刻設定

サイクルオプション:
  --issue-id=123    # 特定ISSUE強制実行
  --create-only     # ISSUE生成のみ実行
  --pr-check-only   # PR監視のみ実行
  --dry-run         # 実際の変更なしシミュレーション
  --force           # エラー状態でも強制実行

実行例:
  /autonomous cycle --dry-run
  
  🔄 手動サイクル実行開始 (dry-run モード)
  
  1. PR状況確認...
     - 監視中PR: 2個
     - 完了待ちPR: 1個
     
  2. 次ISSUE検索...
     - 候補ISSUE発見: 5個
     - 最適選択: "#789 - データベース最適化"
     - 実行可能性スコア: 87/100
     
  3. オーケストレーター実行予定
     - 推定完了時間: 2.5時間
     - 作成予定ブランチ: "feat/auto-789-db-optimization"
     
  🚨 DRY-RUN: 実際の実行はされません
  
  実際に実行する場合:
  /autonomous cycle --issue-id=789
```

### `/autonomous stop [options]`
自律システムを停止

```text
AUTONOMOUS_STOP_EXECUTION:

停止シーケンス:
  1. 🛑 新規サイクル開始停止
  2. ⏳ 現在実行中タスク完了待機
  3. 📊 最終状態保存
  4. 📋 停止レポート生成
  5. 🧹 リソースクリーンアップ

停止オプション:
  --force           # 実行中タスクも即座に停止
  --graceful        # 現在のタスク完了を待機 (デフォルト)
  --save-state      # 状態保存して中断再開可能に
  --cleanup         # 一時ファイル・ブランチクリーンアップ

停止完了メッセージ:
  🛑 自律開発システム停止完了
  
  実行サマリー:
  - 稼働時間: 3日 7時間 45分
  - 完了ISSUE: 31個
  - 作成PR: 29個  
  - マージ済み: 27個
  - 成功率: 93%
  
  📊 最終レポート: .claude/autonomous-final-report.md
  🔄 再開コマンド: /autonomous start --resume
```

### `/autonomous config [action] [key] [value]`
設定の表示・変更

```text
AUTONOMOUS_CONFIG_MANAGEMENT:

設定操作:
  /autonomous config show              # 全設定表示
  /autonomous config get <key>         # 特定設定値取得
  /autonomous config set <key> <value> # 設定値変更
  /autonomous config reset             # デフォルト設定にリセット
  /autonomous config export <file>     # 設定をファイルにエクスポート
  /autonomous config import <file>     # ファイルから設定をインポート

主要設定項目:
  cycle_interval_minutes: 30           # サイクル実行間隔
  max_wait_for_ci_hours: 2            # CI最大待機時間
  max_concurrent_prs: 3               # 同時実行可能PR数
  issue_auto_creation: true           # ISSUE自動生成有効
  auto_merge_enabled: false           # 自動マージ有効
  
  search_labels:                      # ISSUE検索ラベル
    - "ready-for-development"
    - "approved"
    - "good-first-issue"
    
  exclude_labels:                     # 除外ラベル
    - "blocked"
    - "waiting-for-review"
    - "needs-requirements"

設定例:
  # サイクル間隔を15分に変更
  /autonomous config set cycle_interval_minutes 15
  
  # 自動マージを有効化
  /autonomous config set auto_merge_enabled true
  
  # 検索ラベル追加
  /autonomous config add search_labels "enhancement"
```

### `/autonomous logs [options]`
ログとメトリクスの確認

```text
AUTONOMOUS_LOGS_DISPLAY:

ログオプション:
  --last=24h        # 過去24時間のログ
  --level=info      # ログレベル指定 (debug|info|warn|error)
  --filter=error    # エラーのみ表示
  --follow          # リアルタイム追跡
  --export=json     # JSON形式でエクスポート

ログ例:
  2024-06-24 10:15:00 [INFO] Autonomous cycle #47 started
  2024-06-24 10:15:01 [INFO] PR monitoring: 2 PRs in progress  
  2024-06-24 10:15:02 [INFO] Issue search: 8 candidates found
  2024-06-24 10:15:03 [INFO] Selected issue #456 (score: 92/100)
  2024-06-24 10:15:04 [INFO] Orchestrator execution started
  2024-06-24 10:18:22 [WARN] CI check taking longer than expected
  2024-06-24 10:45:33 [INFO] PR #125 created successfully
  2024-06-24 10:45:34 [INFO] Cycle #47 completed (duration: 30m 34s)

メトリクス表示:
  /autonomous logs --metrics --period=week
  
  📊 週次パフォーマンス メトリクス
  
  生産性:
  - 完了ISSUE: 12個
  - 作成PR: 11個
  - マージ済み: 10個
  - 平均サイクル時間: 3.2時間
  
  品質:
  - CI成功率: 91%
  - レビュー一発承認率: 78%
  - バグ導入率: 2.1%
  - コードカバレッジ維持: 99%
  
  効率性:
  - API呼び出し/サイクル: 15回
  - リソース使用率: 67%
  - 待機時間率: 23%
  - アクティブ開発率: 77%
```

---

## ⚙️ 設定ファイル管理

### デフォルト設定ファイル生成
```yaml
# .claude/autonomous-config.yaml
autonomous_system:
  enabled: true
  version: "1.0.0"
  
execution:
  cycle_interval_minutes: 30
  max_wait_for_ci_hours: 2
  max_concurrent_prs: 3
  auto_retry_failed_tasks: true
  auto_merge_enabled: false
  
github:
  api_base_url: "https://api.github.com"
  rate_limit_margin: 100
  webhook_secret: ""
  
issue_management:
  auto_creation_enabled: true
  creation_interval_cycles: 5
  max_generated_per_day: 5
  
  search_labels:
    - "ready-for-development"
    - "approved" 
    - "good-first-issue"
    
  exclude_labels:
    - "blocked"
    - "waiting-for-review"
    - "needs-requirements"
    - "duplicate"
    
  priority_weights:
    urgent: 100
    high: 80
    medium: 60
    low: 40
    
pr_monitoring:
  check_interval_minutes: 5
  max_ci_wait_hours: 2
  auto_request_review: true
  auto_resolve_conflicts: false
  
notifications:
  enabled: true
  levels: ["warn", "error"]
  channels:
    - github_comments
    - console_output
    
logging:
  level: "info"
  max_file_size_mb: 100
  retention_days: 30
  export_format: "json"
  
quality_gates:
  min_code_coverage: 80
  max_complexity_score: 10
  require_security_scan: true
  require_performance_check: false
```

### 実行状態ファイル
```json
{
  "autonomous_state": {
    "status": "running",
    "current_cycle": 47,
    "start_time": "2024-06-21T09:00:00Z",
    "last_cycle_time": "2024-06-24T10:45:34Z",
    "next_cycle_time": "2024-06-24T11:15:34Z",
    
    "statistics": {
      "total_cycles": 47,
      "completed_issues": 23,
      "created_prs": 21,
      "merged_prs": 19,
      "success_rate": 0.94,
      "avg_cycle_duration_minutes": 192
    },
    
    "current_activity": {
      "active_issue_id": "#456",
      "active_pr_number": 125,
      "current_branch": "feat/auto-456-auth-improvements",
      "execution_start": "2024-06-24T10:15:04Z",
      "estimated_completion": "2024-06-24T12:45:04Z"
    },
    
    "monitoring_prs": [
      {
        "number": 123,
        "url": "https://github.com/owner/repo/pull/123",
        "branch": "feat/auto-455-user-profile",
        "ci_status": "success",
        "review_status": "pending",
        "mergeable": true
      }
    ],
    
    "recent_completions": [
      {
        "cycle": 46,
        "issue_id": "#455",
        "pr_number": 124,
        "completion_time": "2024-06-24T09:15:00Z",
        "duration_minutes": 180,
        "status": "success"
      }
    ]
  }
}
```

---

## 🚨 エラーハンドリング & 通知

### 自動回復シナリオ
```text
AUTONOMOUS_ERROR_RECOVERY:

システム障害時:
  api_rate_limit_exceeded:
    - 指数バックオフ待機
    - サイクル間隔自動調整
    - 優先度高いタスクのみ継続
    
  github_api_unavailable:
    - 接続再試行 (最大5回)
    - ローカルキャッシュデータ使用
    - オフラインモード切り替え
    
  ci_infrastructure_failure:
    - CI関連タスク一時停止
    - 代替検証方法実行
    - 手動介入要求生成

実行エラー時:
  orchestrator_timeout:
    - タスク複雑度削減
    - 簡略化バージョン実行
    - エラー詳細レポート作成
    
  repeated_failures:
    - 問題ISSUE一時ブラックリスト
    - 代替ISSUE選択
    - システム管理者通知

データ整合性エラー:
  state_file_corruption:
    - バックアップから復元
    - 安全な初期状態へリセット
    - データ修復レポート生成
    
  git_repository_issues:
    - ローカルリポジトリクリーンアップ
    - リモートとの同期確認
    - 作業ブランチ整理
```

### 通知システム
```text
AUTONOMOUS_NOTIFICATIONS:

通知トリガー:
  success_milestones:
    - 10個のISSUE完了毎
    - 週次サマリーレポート
    - 月次インパクト分析
    
  attention_required:
    - CI失敗が1時間以上継続
    - 利用可能ISSUE不足
    - エラー率20%以上
    - 手動介入必要
    
  system_events:
    - 自律システム開始/停止
    - 設定変更
    - 重大エラー発生
    - メンテナンス実行

通知チャンネル:
  github_integration:
    - ISSUE/PRコメント
    - プロジェクトボード更新
    - ラベル自動管理
    
  console_output:
    - リアルタイムステータス
    - 進捗インジケーター
    - エラー・警告表示
    
  file_reports:
    - 詳細ログファイル
    - メトリクスレポート
    - エラー分析レポート

通知例:
  🎉 自律システム達成報告
  
  今週の成果:
  - 完了ISSUE: 12個
  - マージPR: 11個
  - コード品質スコア: A-
  - 新機能: 3個
  - バグ修正: 4個
  - パフォーマンス改善: 2個
  
  来週の予定:
  - セキュリティ強化フォーカス
  - テストカバレッジ向上
  - ドキュメント整備
  
  📊 詳細レポート: .claude/reports/weekly-2024-25.md
```

---

この統合自律システムにより、**プロジェクトが完全に自動で継続的に改善・発展**していきます。