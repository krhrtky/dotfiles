# リファクタリングSkill

コードリファクタリングを安全に実行します。分析 → 計画 → 実行 → 検証のワークフローでコード品質を向上させます。

**使用法**: `/refact [対象ファイル/ディレクトリ、または要望]`

---

## 設計原則

### 予防的設計（Preventive Design）

> 参照: [信頼性の高いコードを育てる](https://speakerdeck.com/twada/growing-reliable-code-php-conference-fukuoka-2025) by t-wada

本Skillは「防御的コーディング」ではなく「予防的設計」の観点でリファクタリングを提案します。

| 観点 | 防御的（従来） | 予防的（推奨） |
|------|--------------|--------------|
| バリデーション | 実行時にチェック | 型システムで表現 |
| 状態管理 | mutableな状態を検証 | immutableで変更不可に |
| 値の制約 | if文で範囲チェック | 値オブジェクトで制約を型に |
| 不正状態 | フラグで検出 | 表現自体を不可能に |

**コア原則**: 「誤りを想定してチェックするのではなく、そもそも誤りにくい設計を目指す」

---

## 概要

このSkillは4つのsub-agentに分割されており、コンテキスト消耗を防ぎながら安全にリファクタリングを実行します。

```
User Request
    ↓
refactoring-orchestrator-agent（状態管理・遷移制御）
    ↓
refactoring-analysis-agent（スコープ特定 + スメル検出 + 計画策定）
    ↓
refactoring-execution-agent（実行 + 検証 + 品質ゲート）
    ↓
Complete / Escalate
```

## 実行内容

指定されたリクエスト `$ARGUMENTS` に対して以下を実行:

### Step 1: 状態ファイル初期化

```bash
# 既存の状態ファイルを確認
cat .claude/refactoring-state.json 2>/dev/null || echo 'INIT'

# 新規または再開を判定
# COMPLETE/ESCALATED 以外は再開
```

### Step 2: Orchestrator Agent起動

```
Task(refactoring-orchestrator-agent,
  request: "$ARGUMENTS",
  state_file: ".claude/refactoring-state.json")
```

オーケストレーターが以下を制御:
1. Analysis Agent を呼び出してスコープ特定・スメル検出・計画策定
2. Execution Agent を呼び出してリファクタリング実行・検証
3. 検証結果に基づいてリトライまたは完了判定

### Step 3: 完了レポート

ワークフロー完了時に以下を出力:
- 検出されたコードスメル一覧
- 実行されたリファクタリング一覧
- 検証結果サマリー
- 変更ファイル一覧

---

## サポートするリファクタリング

### Extract系
| 種類 | 説明 | 対象スメル |
|------|------|-----------|
| `extract_function` | 関数の抽出 | 長い関数、重複コード |
| `extract_variable` | 変数の抽出 | 複雑な式、マジックナンバー |
| `extract_class` | クラスの抽出 | 大きすぎるクラス |
| `extract_interface` | インターフェースの抽出 | 共通メソッドシグネチャ |

### Inline系
| 種類 | 説明 | 対象スメル |
|------|------|-----------|
| `inline_function` | 関数のインライン化 | 単純すぎる関数 |
| `inline_variable` | 変数のインライン化 | 不要な一時変数 |

### Move系
| 種類 | 説明 | 対象スメル |
|------|------|-----------|
| `move_function` | 関数の移動 | 責務の不一致 |
| `move_field` | フィールドの移動 | 責務の不一致 |

### Rename系
| 種類 | 説明 | 対象スメル |
|------|------|-----------|
| `rename_variable` | 変数名の変更 | 不明確な命名 |
| `rename_function` | 関数名の変更 | 不明確な命名 |
| `rename_parameter` | パラメータ名の変更 | 不明確な命名 |
| `rename_class` | クラス名の変更 | 不明確な命名 |

### Simplify系
| 種類 | 説明 | 対象スメル |
|------|------|-----------|
| `simplify_conditional` | 条件式の簡素化 | 複雑な条件分岐 |
| `replace_nested_with_guard` | ガード節への置換 | 深いネスト |
| `decompose_conditional` | 条件式の分解 | 複雑な条件式 |
| `remove_dead_code` | デッドコードの除去 | 未使用コード |

### 予防的設計系（Preventive Design）
| 種類 | 説明 | 対象スメル |
|------|------|-----------|
| `introduce_value_object` | 値オブジェクトの導入 | 基本型でドメイン概念を表現 |
| `replace_validation_with_type` | バリデーションを型制約に置換 | 実行時検証が多い |
| `make_immutable` | 不変化 | 変更不要なmutable状態 |
| `make_illegal_states_unrepresentable` | 不正状態を表現不可能に | 不正状態が作成可能 |
| `introduce_domain_object` | ドメインオブジェクトの導入 | 配列での代用 |
| `replace_string_with_enum` | 文字列をenumに置換 | 文字列での有限集合表現 |
| `introduce_factory_method` | ファクトリメソッドの導入 | 不正なインスタンス生成可能 |

---

## 検出するコードスメル

### 従来のスメル

| スメル | 検出条件 | 重要度 |
|--------|---------|--------|
| `long_function` | 関数が30行以上 | HIGH(50行+) / MEDIUM |
| `large_class` | クラスが300行以上 or メソッド10個以上 | HIGH(500行+) / MEDIUM |
| `duplicated_code` | 5行以上の重複コード | HIGH(10行+) / MEDIUM |
| `complex_conditional` | ネスト3階層以上 or 条件3個以上 | HIGH(5階層+) / MEDIUM |
| `long_parameter_list` | パラメータ5個以上 | MEDIUM |
| `magic_numbers` | ハードコードされた数値リテラル | LOW |
| `dead_code` | 未使用の関数/変数/import | LOW |
| `unclear_naming` | 1-2文字の変数名、意味不明な命名 | LOW |

### 予防的設計のスメル

| スメル | 検出条件 | 重要度 |
|--------|---------|--------|
| `primitive_obsession` | ドメイン概念を基本型(string, number)で表現 | MEDIUM |
| `defensive_validation` | 型で表現可能な制約を実行時バリデーションで検証 | MEDIUM |
| `mutable_state` | 不変にできる状態がmutable | MEDIUM |
| `invalid_state_possible` | 不正な状態（開始日>終了日等）が表現可能 | HIGH |
| `stringly_typed` | 文字列で有限集合（status等）を表現 | LOW |
| `aliasing_risk` | 参照型の共有による意図しない変更リスク | HIGH |

---

## 使用例

### 例1: 特定ファイルのリファクタリング

```bash
/refactor src/services/user.ts
```

対象ファイルを分析し、検出されたスメルに対してリファクタリングを実行。

### 例2: ディレクトリ全体のリファクタリング

```bash
/refactor src/components/
```

ディレクトリ内の全ファイルを分析し、優先順位に従ってリファクタリングを実行。

### 例3: 特定の要望

```bash
/refactor "UserService の validateInput 関数が長いので分割したい"
```

要望に基づいて対象を特定し、適切なリファクタリングを提案・実行。

### 例4: コードスメルの検出のみ

```bash
/refactor --analyze-only src/
```

リファクタリングは実行せず、コードスメルの検出と計画策定のみ実行。

### 例5: 予防的設計の適用

```bash
/refactor "UserService の status を string から enum に変更したい"
```

`stringly_typed` スメルを検出し、`replace_string_with_enum` リファクタリングを提案・実行。

### 例6: 値オブジェクトの導入

```bash
/refactor "email, phoneNumber などの基本型を値オブジェクトに"
```

`primitive_obsession` スメルを検出し、`introduce_value_object` リファクタリングを提案・実行。

### 例7: 並列実行モード（5ファイル以上推奨）

```bash
/refactor --parallel src/services/
```

Agent Teams を使用してリファクタリングを並列実行。5ファイル以上の場合に 50% 以上の高速化が期待できます。

---

## 状態管理

ワークフロー状態は `.claude/refactoring-state.json` に保存されます:

```json
{
  "id": "refactor-1705312800",
  "request": "src/services/user.ts",
  "current_phase": "EXECUTION",
  "iteration": 0,
  "scope": {...},
  "smells_detected": [...],
  "refactoring_plan": [...],
  "execution_log": [...],
  "phase_history": [...],
  "blocker_history": [],
  "created_at": "2024-01-15T10:00:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

### 中断からの再開

実行が中断された場合、再度 `/refactor` を実行すると前回の状態から再開します。

### 状態のリセット

```bash
rm .claude/refactoring-state.json
```

---

## エスカレーション

以下の条件でエスカレーションが発生し、人間の判断を求めます:

| 条件 | 説明 |
|------|------|
| リトライ上限 | 3回のリトライで解決しない |
| 重複ブロッカー | 同じ問題が2回以上検出 |
| テスト連続失敗 | 2回連続でテスト失敗 |

エスカレーション時は以下が報告されます:
- 未解決のブロッカー一覧
- 実行履歴
- 推奨アクション

---

## 検証項目

各リファクタリング後に以下を検証:

| 検証項目 | コマンド例 |
|---------|-----------|
| テスト | `npm test` / `pytest` / `go test ./...` |
| Lint | `npm run lint` / `ruff check` / `golangci-lint run` |
| 型チェック | `tsc --noEmit` / `mypy` / `go build` |

全ての検証がパスした場合のみ、リファクタリングが確定されます。

---

## 注意事項

1. **テストカバレッジ**: テストが存在しないコードへのリファクタリングは警告が表示されます
2. **git状態**: 未コミットの変更がある場合、stashされます
3. **バックアップ**: 各リファクタリング前にgit状態が保存されます
4. **ロールバック**: 検証失敗時は自動的にロールバックされます

---

## 自動判断機能（Phase 3）

ファイル数に基づいて、自動的に最適な実行モードを推奨します。

### 判断基準

| ファイル数 | 推奨モード | 理由 |
|----------|----------|------|
| 1-2ファイル | Sequential | 並列化のオーバーヘッドが大きい |
| 3-4ファイル | Sequential | トークンコスト増加に見合う効果が限定的 |
| 5-9ファイル | Parallel | 50% 以上の高速化が期待できる（依存関係が少ない場合） |
| 10+ファイル | Parallel | 60-70% 以上の高速化が期待できる（依存関係が少ない場合） |

**依存関係の考慮**:
- ファイル間に依存関係がある場合、Sequential を推奨
- 独立したファイルの場合のみ Parallel を推奨

### 使用例

```bash
# 自動判断（ファイル数を分析）
/refact src/components/*.tsx

# 出力例:
#
# 分析結果:
# - 対象ファイル数: 8ファイル
# - 依存関係: 低（並列実行可能）
# - 複雑性: MEDIUM
#
# 推奨方式: Parallel (Agent Teams)
# 理由: 独立した8ファイルのリファクタリングを並列実行できる
#
# 期待効果:
# - 実行速度: 50-60% 高速化
# - トークンコスト: +25% (MEDIUM)
#
# リスク:
# - ファイル競合リスク（低）
# - 統合検証の複雑化
#
# 確信度: 90%
#
# この推奨方式で進めますか? [Y/n]
```

### 強制的にモードを指定

自動判断をスキップして、明示的にモードを指定することもできます。

```bash
# Sequential モードを強制
/refact --mode=sequential src/components/*.tsx

# Parallel モードを強制
/refact --mode=parallel src/components/*.tsx
```

---

## 並列実行モード（Agent Teams）

### 概要

`--parallel` オプションを使用すると、EXECUTION フェーズで Agent Teams を使って複数のリファクタリングを並列実行します。

### 適用条件

- **推奨**: 5ファイル以上のリファクタリング
- **効果**: 50% 以上の高速化（依存関係が少ない場合）
- **トレードオフ**: トークンコスト増加（最大 30%）

### 動作

```
1. 依存関係グラフを解析
2. 並列実行可能なバッチに分割
   - Batch 1: 独立した3ファイルを並列実行
   - Batch 1 完了後、統合検証
   - Batch 2: 次の独立グループを並列実行
3. ファイル競合を 100% 検出
4. バッチ単位で検証・ロールバック
```

### 使用例

```bash
# 並列実行モードを有効化
/refactor --parallel src/services/

# Sequential モード（デフォルト）
/refactor src/services/
```

### 制約

- 同一ファイルへの変更は直列実行
- 依存関係のあるリファクタリングは直列実行
- バッチ失敗時は全体ロールバック

---

## 関連Skill

- `/task`: 単一タスクの高速実行
- `/orchestrate`: 複雑なマルチエージェントワークフロー
- `/analyze`: プロジェクト分析
