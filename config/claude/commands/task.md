# 🎯 高速タスク実行

単一の明確なタスクを効率的に実行します。オーケストレーターよりも軽量で、シンプルなタスクに最適化されています。

**使用法**: `/task <task_description>`

---

## 📋 実行内容

指定されたタスク `$ARGUMENTS` を以下の手順で実行:

### Step 1: タスク分析
```text
1. タスクの性質判定:
   - 単純作業 (1-2時間): 直接実行
   - 中程度作業 (2-4時間): 軽量分解実行
   - 複雑作業 (4時間以上): オーケストレーターを推奨

2. 実行戦略決定:
   - 単一ファイル修正: 直接編集
   - 複数ファイル関連: Task Tools活用
   - 新機能追加: container-use環境使用
```

### Step 2: 実行方法選択

#### 🚀 高速直接実行（単純タスク）
```text
適用条件:
- 1-3個のファイル修正
- 明確な作業内容
- 外部依存なし

実行内容:
1. 関連ファイル特定・読み込み
2. 要求された変更実装
3. 基本テスト・検証実行
4. 変更内容コミット
```

#### ⚡ Task Tools活用（中程度タスク）
```text
適用条件:
- 複数コンポーネント関連
- 調査・分析が必要
- テスト作成が必要

実行内容:
@task-parallel task-execution
- task_id: main-implementation
  description: |
    メインロジックの実装
    要件: $ARGUMENTS
    
- task_id: test-creation
  description: |
    対応するテストケース作成
    カバレッジ確保
    
- task_id: documentation
  description: |
    必要に応じてドキュメント更新
@end-parallel
```

#### 🏗️ Container-Use実行（複雑タスク）
```text
適用条件:
- 新機能・大きな変更
- 環境構築が必要
- 統合テストが必要

実行内容:
1. 専用container-use環境作成
2. 独立ブランチで作業
3. 完全なテスト実行
4. PR作成・CI確認
```

### Step 3: 品質確認
```text
1. 実装内容検証:
   - 要件との照合
   - エラー・警告チェック
   - 基本動作確認

2. コード品質チェック:
   - Linter実行
   - 型チェック実行
   - セキュリティスキャン

3. テスト実行:
   - 関連テストスイート実行
   - 新規テスト作成（必要時）
   - カバレッジ確認
```

### Step 4: 完了処理
```text
1. 変更内容整理:
   - コミットメッセージ作成
   - 変更ファイル一覧
   - 影響範囲まとめ

2. 次のアクション提示:
   - PR作成手順
   - 追加で必要な作業
   - 関連タスクの提案
```

---

## 🎛️ タスク種別別の実行パターン

### 🐛 バグ修正
```text
実行フロー:
1. 問題箇所特定（ログ分析、デバッグ）
2. 根本原因分析
3. 最小限の修正実装
4. リグレッションテスト追加
5. 修正内容の文書化

期待時間: 30分-2時間
使用ツール: Read, Edit, Bash, Grep
```

### ✨ 新機能追加
```text
実行フロー:
1. 既存アーキテクチャ理解
2. 設計方針決定
3. 段階的実装
4. テストケース作成
5. ドキュメント更新

期待時間: 1-4時間
使用ツール: Task, container-use, GitHub
推奨: 複雑な場合は/orchestrateを使用
```

### 🔧 リファクタリング
```text
実行フロー:
1. 現状コード分析
2. 改善箇所特定
3. 段階的リファクタリング実行
4. 既存テストでの回帰確認
5. パフォーマンス影響測定

期待時間: 1-3時間
使用ツール: MultiEdit, Bash, Grep
注意点: テストカバレッジ維持
```

### 📝 ドキュメント作成
```text
実行フロー:
1. 既存ドキュメント確認
2. 不足箇所特定
3. 構造化された文書作成
4. 例・図表追加
5. 関連リンク整備

期待時間: 30分-2時間
使用ツール: Write, Read, WebFetch
```

### 🧪 テスト追加
```text
実行フロー:
1. 現在のテストカバレッジ分析
2. 不足しているテストケース特定
3. テストシナリオ設計
4. テストコード実装
5. CI/CDでの実行確認

期待時間: 1-3時間
使用ツール: Read, Write, Bash
```

### ⚡ パフォーマンス最適化
```text
実行フロー:
1. ボトルネック分析
2. プロファイリング実行
3. 最適化実装
4. ベンチマーク測定
5. 改善効果確認

期待時間: 2-4時間
使用ツール: Bash, container-use, 分析ツール
推奨: 複雑な場合は/orchestrateを使用
```

---

## 📊 実行結果フォーマット

### 成功時のレポート
```text
<<< TASK_COMPLETED
task: "$ARGUMENTS"
execution_time: "45 minutes"
approach: "direct_implementation"

changes_made:
  files_modified: 3
  lines_added: 47
  lines_removed: 12
  
  files:
    - src/components/UserProfile.tsx
    - src/utils/validation.ts
    - tests/components/UserProfile.test.tsx

quality_checks:
  linter: "passed"
  type_check: "passed"
  tests: "8/8 passed"
  security_scan: "no issues"

deliverables:
  - "ユーザープロファイル更新機能実装"
  - "バリデーション強化"
  - "対応するテストケース追加"

next_steps:
  - "git add . && git commit -m 'feat: enhance user profile update'"
  - "git push origin feature/user-profile-enhancement"
  - "PR作成: 'feat: ユーザープロファイル更新機能強化'"

estimated_review_time: "15-30分"
>>>
```

### 部分完了時のレポート
```text
<<< TASK_PARTIALLY_COMPLETED
task: "$ARGUMENTS" 
status: "core_implementation_done"
completion: 80%

completed_work:
  - "メイン機能実装完了"
  - "基本テストケース追加"
  - "型定義更新"

remaining_work:
  - "エラーハンドリング強化"
  - "統合テスト追加"
  - "ドキュメント更新"

automatic_follow_up:
  created_issues:
    - "#123: エラーハンドリング強化"
    - "#124: 統合テスト追加"
  
next_action: "残りタスクを/taskまたは/orchestrateで実行"
>>>
```

### エスカレーション時のレポート
```text
<<< TASK_ESCALATION_REQUIRED
task: "$ARGUMENTS"
escalation_reason: "complexity_exceeds_threshold"
analysis_time: "15 minutes"

complexity_indicators:
  - "5つ以上のコンポーネントに影響"
  - "データベーススキーマ変更が必要"
  - "外部API統合が必要"
  - "推定実行時間: 6-8時間"

recommendation: |
  このタスクは複雑度が高いため、以下を推奨します:
  
  /orchestrate $ARGUMENTS
  
  または段階的に分割:
  1. /task "データベーススキーマ設計と実装"
  2. /task "外部API統合レイヤー実装"  
  3. /task "フロントエンド機能実装"
  4. /task "統合テストと最終調整"

estimated_total_time: "6-8時間"
recommended_approach: "orchestrate"
>>>
```

---

## ⚙️ 実行時設定

### タスク実行設定
```yaml
task_execution:
  max_execution_time_hours: 2
  auto_escalate_threshold_hours: 3
  quality_gate_enforcement: true
  auto_test_execution: true
  
complexity_thresholds:
  simple_task:
    max_files: 3
    max_hours: 2
    auto_execution: true
    
  medium_task:  
    max_files: 8
    max_hours: 4
    use_task_tools: true
    
  complex_task:
    escalate_to: "orchestrate"
    create_subtasks: true
```

### 品質設定
```yaml
quality_requirements:
  code_style:
    run_linter: true
    run_formatter: true
    enforce_standards: true
    
  testing:
    run_existing_tests: true
    require_new_tests: "auto_detect"
    min_coverage_change: 0  # カバレッジ低下を許可しない
    
  security:
    run_security_scan: true
    check_dependencies: true
    validate_input_handling: true
```

---

## 🚨 エラーハンドリング

### 自動回復パターン
```text
Implementation Error:
1. 構文エラー → 自動修正試行
2. 型エラー → 型定義更新
3. テスト失敗 → テストデータ調整
4. 依存関係エラー → パッケージ更新

Resource Limitation:
1. メモリ不足 → 処理の分割実行
2. 時間制限 → 部分実装での完了
3. API制限 → キャッシュデータ活用
4. 権限不足 → 権限取得ガイド提示

Complexity Overflow:
1. 推定時間超過 → オーケストレーター推奨
2. ファイル数過多 → 段階的分割提案
3. 依存関係複雑 → 依存関係分析レポート
4. 技術的課題 → エキスパート相談提案
```

### マニュアル介入ポイント
```text
Automatic Escalation Triggers:
- 3回連続で同じエラー発生
- 実行時間が推定の150%を超過
- 5つ以上のコンポーネントに影響
- セキュリティリスクレベル中以上
- テストカバレッジ10%以上低下
```

---

## 🎨 使用例

### 例1: 簡単なバグ修正
```bash
/task "ユーザーログイン時にエラーメッセージが表示されない問題を修正"

# 実行: 直接実行パターン
# 時間: 30分
# 結果: 1-2ファイル修正、テスト追加
```

### 例2: 新機能追加
```bash
/task "商品検索にフィルター機能を追加"

# 実行: Task Tools活用パターン
# 時間: 2-3時間  
# 結果: フロントエンド+バックエンド+テスト
```

### 例3: 複雑な機能（エスカレーション）
```bash
/task "決済システム全体のリファクタリング"

# 結果: 複雑度判定により自動エスカレーション
# 推奨: /orchestrate "決済システム全体のリファクタリング"
```

---

この最適化されたタスク実行システムにより、適切な規模のタスクを効率的かつ高品質に完了できます。