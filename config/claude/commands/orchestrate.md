# 🎼 オーケストレーター

複雑なタスクを独立可能な粒度に分解し、container-use環境で並列実行します。

**使用法**: `/orchestrate <task_description>`

---

## 📋 実行内容

指定されたタスク `$ARGUMENTS` を以下の手順で実行:

### Phase 1: 初期分析
1. **要件分析**: タスクの目的・背景・期待成果を明確化
2. **依存関係特定**: 実行順序と前提条件を特定
3. **アーキテクチャ設計**: 全体的な実装方針決定

### Phase 2: ステップ設計
1. **タスク分解**: 2〜5個のステップに分割
2. **並列化設計**: 各ステップ内で2〜4個の独立サブタスクを配置
3. **実行プラン策定**: container-use環境での並列実行計画

### Phase 3: Task Tools並列実行
```text
@task-parallel <ステップ名>-phase
execution_strategy: parallel
max_concurrent: 4
timeout_minutes: 120
failure_strategy: continue_on_error

- task_id: t-<step>-1
  description: |
    <Task Toolsへの明確な指示>
    Goal: <期待する具体的成果物>
    Context: <必要な背景情報>
    Deliverables: <成果物の詳細>
  tools_required: [container-use, github, file-operations]
  environment: |
    source: /path/to/project
    name: task-t-<step>-1-env
    
- task_id: t-<step>-2
  description: |
    <次のタスクの指示>
  independent: true
  environment: |
    source: /path/to/project  
    name: task-t-<step>-2-env
    
@end-parallel
```

### Phase 4: レビュー & 適応
1. **品質チェック**: 各ステップ完了後の結果確認
2. **プラン修正**: 必要に応じて動的に計画調整
3. **統合確認**: サブタスク間の整合性確認

### Phase 5: 完了検証
1. **全ゴール達成確認**: 当初の要件との照合
2. **最終統合**: 各container-use環境からの成果物統合
3. **Pull Request作成**: 統合された変更でPR作成

### Phase 6: 最終統合
```text
@task-sequential final-integration
- task_id: integration-check
  description: |
    全コンポーネントの統合テストを実行
    すべてのPRの互換性確認と競合解決
    
- task_id: quality-validation
  description: |
    最終品質チェック実行
    自動テスト、セキュリティスキャン、パフォーマンステスト
    
- task_id: pr-creation
  description: |
    統合要約を含む最終PRを作成
    タイトル: "feat: <タスク全体要約>"
    本文: 全フェーズの詳細要約とTask Tools実行ログ
@end-sequential
```

---

## 🔧 Container-Use環境管理

### 環境作成戦略
```text
独立環境作成:
1. 各サブタスクに専用のcontainer-use環境を作成
2. プロジェクトソースの独立コピーで作業
3. 独立したGitブランチで変更管理
4. 環境間の干渉を完全に排除

並列実行管理:
1. 依存関係のないタスクを同時に複数環境で実行
2. リソース使用量に基づく動的スケジューリング
3. 環境の健全性監視と自動復旧
4. 完了タスクの環境クリーンアップ

統合処理:
1. 各環境の成果物をリモートリポジトリにプッシュ
2. 統合専用環境で全変更をマージ
3. 統合後の全体テスト・Lint実行
4. 最終PRとして変更を提出
```

### 環境固有ブランチ戦略
```bash
# メインタスク用ブランチ
feature/orchestrate-{task-id}-main

# サブタスク用ブランチ
feature/orchestrate-{task-id}-subtask-1
feature/orchestrate-{task-id}-subtask-2
feature/orchestrate-{task-id}-subtask-3

# 統合用ブランチ
feature/orchestrate-{task-id}-integration
```

---

## 🎯 Task Tools活用パターン

### 並列実行最適化
```text
# 機能開発の場合
@task-parallel feature-development
- task_id: backend-api
  description: |
    REST APIエンドポイントを設計・実装
    認証、CRUD操作、エラーハンドリング含む
  environment: |
    name: backend-api-env
    
- task_id: frontend-components  
  description: |
    Reactコンポーネントライブラリを作成
    UI/UX設計に基づいたレスポンシブ対応
  environment: |
    name: frontend-components-env
    
- task_id: database-schema
  description: |
    データベーススキーマ設計と初期データ投入
  environment: |
    name: database-schema-env
@end-parallel

# テスト・品質保証の場合
@task-parallel quality-assurance
- task_id: unit-tests
  description: |
    新機能の単体テスト作成
  environment: |
    name: unit-tests-env
    
- task_id: integration-tests
  description: |
    APIとフロントエンドの統合テスト
  environment: |
    name: integration-tests-env
    
- task_id: performance-tests
  description: |
    パフォーマンステストとベンチマーク
  environment: |
    name: performance-tests-env
@end-parallel
```

### 条件付き実行制御
```text
@task-conditional
condition: if_previous_success
@task-parallel validation-phase
- task_id: security-scan
  description: |
    セキュリティ脆弱性スキャン実行
    
- task_id: accessibility-check
  description: |
    アクセシビリティ準拠チェック
@end-parallel
@end-conditional
```

---

## 📊 実行結果フォーマット

### タスク完了レポート
```text
<<< ORCHESTRATION_RESULT
total_tasks: 8
completed_tasks: 8  
failed_tasks: 0
execution_time_minutes: 45
parallel_efficiency: 85%

phase_summary:
  - phase: requirements-analysis
    duration_minutes: 5
    status: completed
    
  - phase: parallel-development
    duration_minutes: 35
    status: completed
    parallel_tasks: 4
    
  - phase: integration
    duration_minutes: 5
    status: completed

deliverables:
  - type: feature
    description: "ユーザー認証システム実装"
    files_changed: 12
    tests_added: 8
    
  - type: pr
    url: "https://github.com/owner/repo/pull/456"
    branch: "feature/orchestrate-auth-system"
    mergeable: true
    ci_status: "pending"

quality_metrics:
  - code_coverage: 92%
  - security_scan: "passed"
  - performance_impact: "low"
  - complexity_score: "B+"

next_steps:
  - "PR #456のCI完了を監視"
  - "レビュー承認後の自動マージ"
  - "関連ISSUEのクローズ"
>>>
```

### エラー時の詳細レポート
```text
<<< ORCHESTRATION_ERROR
failed_task: "t-backend-3"
error_type: "build_failure"
error_message: "TypeScript compilation failed"

recovery_actions_taken:
  1. "依存関係の更新実行"
  2. "型定義ファイルの修正"
  3. "簡略化バージョンで再実行"

manual_intervention_required:
  issue_created: "#789"
  issue_title: "[AUTO] TypeScript型エラー修正が必要"
  issue_url: "https://github.com/owner/repo/issues/789"
  
continuation_plan:
  - "他のタスクは正常完了"
  - "部分的なPR作成済み"
  - "手動修正後に統合予定"
>>>
```

---

## ⚙️ 最適化設定

### 並列実行制御
```yaml
orchestration_config:
  max_parallel_tasks: 4
  max_execution_time_hours: 4
  auto_retry_count: 3
  failure_tolerance: 25%  # 25%のタスクが失敗しても継続
  
container_management:
  max_environments: 6
  environment_timeout_hours: 6
  auto_cleanup: true
  resource_monitoring: true
  
quality_gates:
  require_all_tests_pass: true
  min_code_coverage: 80
  max_security_issues: 0
  performance_regression_threshold: 10%
```

### Task Tools最適化
```yaml
task_tools_optimization:
  resource_management:
    task_affinity: group_similar_tasks
    memory_optimization: reuse_tools_context
    cpu_scheduling: balance_computational_load
    
  parallel_efficiency:
    dependency_minimization: true
    granularity_optimization: auto_split_large_tasks
    load_balancing: distribute_work_evenly
    early_termination: fast_fail_on_critical_errors
```

---

## 🚨 エラーハンドリング

### 自動回復シナリオ
```text
Task失敗時の対応:
1. エラーログ分析による原因特定
2. 自動修正可能な問題の解決実行
3. 簡略化バージョンでの再実行
4. 他のタスクとの依存関係調整

Environment障害時の対応:
1. 環境の健全性チェック
2. 必要に応じて環境再作成
3. 作業状態の復元
4. 実行継続可能性の判定

統合失敗時の対応:
1. 競合の詳細分析
2. 自動マージ可能な競合の解決
3. 複雑な競合の手動解決ISSUE作成
4. 部分統合による段階的マージ
```

---

この最適化されたオーケストレーターにより、複雑なタスクが効率的に分解・並列実行され、高品質な成果物が確実に生産されます。