## コード実装

### 最優先事項
1. **既存ファイルの編集を優先**: 新規ファイル作成は必要最小限に
2. **コードスタイルの完全準拠**: 既存パターン、命名規則、インデント、フォーマットを厳守
3. **ライブラリ事前確認**: package.json/requirements.txt等で利用可能性を必ず確認
4. **コメント追加禁止**: 明示的要求がない限り一切のコメントを追加しない
5. **セキュリティ最重視**: 秘密情報の露出・ログ出力・コミットを絶対に避ける

### コーディング原則

#### 可読性とシンプルさ
1. **YAGNI (You Aren't Gonna Need It)**: 今必要でない機能は実装しない
2. **KISS (Keep It Simple, Stupid)**: 最もシンプルな解決策を選択
3. **早期リターン**: ネストを減らし、ガード節で早期return
4. **明確な命名**: 変数・関数名は意図が伝わるように命名
5. **マジックナンバー禁止**: 定数として定義し、意味を明確化

#### 関数・メソッド設計
1. **単一責任の原則**: 一つの関数は一つのことだけ行う
2. **引数は最小限**: 理想は0-2個、3個以上は要検討
3. **副作用の最小化**: 純粋関数を優先、状態変更は明示的に
4. **早期失敗**: 異常系は早期に検出してエラーを投げる
5. **デフォルト引数活用**: オプショナルな引数にはデフォルト値

#### データ構造とアルゴリズム
1. **適切なデータ構造選択**: Map/Set/Array等を用途に応じて選択
2. **イミュータブル優先**: 可能な限り不変データを使用
3. **破壊的変更を避ける**: 新しいオブジェクトを返す
4. **時間/空間計算量考慮**: O(n²)以上は要検討

#### エラー処理
1. **明示的エラー**: エラーは隠さず適切に伝播
2. **具体的なエラーメッセージ**: デバッグに必要な情報を含める
3. **リトライ可能性**: 一時的エラーは適切にリトライ
4. **フェイルセーフ**: エラー時も安全な状態を保つ

#### モジュール性
1. **疎結合**: モジュール間の依存は最小限に
2. **インターフェース分離**: 必要な機能だけを公開
3. **依存性注入**: 外部依存はコンストラクタ/引数で注入
4. **循環参照禁止**: モジュール間の循環依存を避ける

### プログラミングスタイル

#### プログラミングパラダイム
1. **関数型プログラミング優先**
   - イミュータビリティ: データの不変性を保つ
   - 純粋関数: 副作用のない予測可能な関数
   - 高階関数: map/filter/reduceの活用
   - 関数合成: 小さな関数を組み合わせて複雑な処理を構築

2. **オブジェクト指向の適切な活用**
   - カプセル化: 内部実装の隠蔽
   - ポリモーフィズム: インターフェースによる抽象化
   - コンポジション優先: 継承より合成を選択
   - SOLID原則: 特に単一責任とインターフェース分離

3. **宣言的プログラミング**
   - 何をするか記述: どうやるかより何をしたいか
   - SQLライク思考: データの変換を宣言的に
   - 設定より規約: 明示的な設定を最小限に

#### TypeScriptサンプル
```typescript
// 関数型アプローチ
const processUsers = (users: User[]): ProcessedUser[] =>
  users
    .filter(user => user.isActive)
    .map(user => ({
      ...user,
      fullName: `${user.firstName} ${user.lastName}`,
      age: calculateAge(user.birthDate)
    }))
    .sort((a, b) => a.age - b.age);

// イミュータブルな更新
const updateUser = (user: User, updates: Partial<User>): User => ({
  ...user,
  ...updates,
  updatedAt: new Date()
});

// Result型パターン
type Result<T, E = Error> = 
  | { success: true; value: T }
  | { success: false; error: E };

const safeDivide = (a: number, b: number): Result<number> =>
  b === 0 
    ? { success: false, error: new Error('Division by zero') }
    : { success: true, value: a / b };
```

#### Kotlinサンプル
```kotlin
// データクラスとイミュータビリティ
data class User(
    val id: String,
    val name: String,
    val email: String,
    val isActive: Boolean = true
)

// 拡張関数と関数型操作
fun List<User>.activeUsers() = filter { it.isActive }

fun List<User>.processUsers(): List<ProcessedUser> =
    activeUsers()
        .map { user ->
            ProcessedUser(
                user = user,
                displayName = user.name.uppercase(),
                domain = user.email.substringAfter('@')
            )
        }
        .sortedBy { it.user.name }

// Sealed classでの型安全なエラーハンドリング
sealed class Result<out T> {
    data class Success<T>(val value: T) : Result<T>()
    data class Error(val exception: Exception) : Result<Nothing>()
}

// スコープ関数の活用
fun createUser(name: String, email: String) = User(
    id = UUID.randomUUID().toString(),
    name = name,
    email = email
).also { 
    logger.info("Created user: ${it.id}")
}.takeIf { 
    it.email.contains("@") 
} ?: throw IllegalArgumentException("Invalid email")
```

#### 共通の原則
1. **Null安全性**: Optional/nullable型の適切な使用
2. **型推論活用**: 明示的な型宣言は必要最小限
3. **早期リターン**: ガード節でネストを減らす
4. **デストラクチャリング**: オブジェクトの分解代入
5. **パターンマッチング**: when/switch式の活用

### 品質保証

#### TDD (Test-Driven Development)
1. **Red-Green-Refactorサイクル**
   - Red: 失敗するテストを最初に書く（仕様の明確化）
   - Green: テストを通す最小限の実装
   - Refactor: 重複除去とコード改善（テストは常にGreen維持）

2. **TDDの黄金律**
   - 失敗するテストなしにプロダクトコードを書かない
   - 失敗を解消する以上のプロダクトコードを書かない
   - 一度に一つの失敗だけに対処する

3. **テストファースト思考**
   - 「どう実装するか」より「何を実現したいか」を先に考える
   - テストが仕様書となるように記述
   - アサーションを先に書き、そこから逆算して実装

4. **小さなステップ**
   - 一度に扱う変更は最小限に
   - 各ステップで動作確認（テスト実行）
   - コミット可能な状態を常に保つ

5. **リファクタリング規律**
   - テストがGreenの時のみリファクタリング
   - 振る舞いを変えずに内部構造を改善
   - テスト自体もリファクタリング対象

#### その他の品質保証
1. **リント・型チェック**: npm run lint, npm run typecheck等で品質検証
2. **エラーハンドリング**: 適切な例外処理とエラーメッセージ
3. **パフォーマンス考慮**: 効率的なアルゴリズムとデータ構造の選択

### コンテキスト管理

#### タスク開始前の必須プロセス
1. **コンテキスト確認**: `.claude/`ディレクトリの存在と内容を確認
2. **コンテキスト判定**: ユーザーの指示から作業コンテキストを特定
3. **コンテキスト切り替え**: 必要に応じて適切なコンテキストをアクティブ化

#### コンテキスト構造
```
.claude/
├── contexts/                 # コンテキスト別ディレクトリ
│   ├── issue-123-feature/    # Issue番号-概要の形式
│   │   ├── context.json      # コンテキストメタデータ
│   │   ├── session.log       # セッション履歴
│   │   └── tasks.md          # タスクリスト
│   └── bugfix-memory-leak/
│       └── ...
└── active-context            # 現在のコンテキストへのリンク
```

#### コンテキスト判定ロジック
1. **指示の分析**: Issue番号、機能名、バグ修正内容を抽出
2. **既存コンテキスト検索**: 
   - 完全一致 → そのコンテキストを継続
   - 部分一致 → ユーザーに確認
   - 不一致 → 新規コンテキスト作成
3. **ブランチとの整合性確認**: 現在のGitブランチと関連付け

#### context.jsonフォーマット
```json
{
  "id": "issue-123-dark-mode",
  "type": "feature|bugfix|refactor",
  "branch": "feature/dark-mode",
  "created": "ISO8601形式の日時",
  "lastActive": "ISO8601形式の日時",
  "description": "作業内容の説明",
  "relatedFiles": ["変更対象ファイルのパス"],
  "status": "active|paused|completed"
}
```

#### セッション管理
1. **開始時**: コンテキスト確認 → 作業履歴読み込み → 未完了タスク確認
2. **作業中**: 重要な変更を`session.log`に記録
3. **終了時**: 作業状態を更新 → 未完了タスクを記録

#### 環境戦略

##### 現在の方針
- **MCP Container-use統一採用**: 全タスクでcontainer-useを使用
- **理由**: 環境分離とセキュリティを最優先
- **利点**: AIとの透過的な連携、破壊的操作からの保護

##### Dev Container移行判断基準
以下の条件が揃った場合、Dev Container併用を検討：
1. **人間開発者の作業比率が50%超**
2. **デバッグ・ブレークポイント利用が頻繁**
3. **VS Code拡張機能への依存が高い**
4. **チーム開発での環境共有が必要**

##### 移行時の考慮事項
```yaml
# 将来の.claude/environment-strategy.yaml
strategy:
  default: "container-use"  # AI作業のデフォルト
  overrides:
    - pattern: "debug-*"
      environment: "devcontainer"
    - pattern: "team-*"
      environment: "devcontainer"
```

##### 環境選択ガイドライン
- **探索的タスク**: container-use（破壊的変更のリスク回避）
- **実装タスク**: container-use（現在の標準）
- **デバッグタスク**: Dev Container（将来的に検討）
- **チーム作業**: Dev Container（将来的に検討）

##### MCP Container-use管理ポリシー

###### コンテキスト別MCP設定
1. **MCPサーバー命名規則**: `{project}-{context-id}`
   - 例: `dotfiles-issue-123`, `dotfiles-feature-auth`
2. **一意性の保証**: 各コンテキストは専用のMCPサーバー設定を使用
3. **並列実行**: 異なるコンテキストのMCPサーバーは同時実行可能

###### MCP設定管理
1. **コンテキスト別設定ファイル**
   ```json
   // .claude/contexts/issue-123/mcp-config.json
   {
     "servers": {
       "issue-123-env": {
         "command": "npx",
         "args": ["@modelcontextprotocol/server-container-use"],
         "env": {
           "CONTAINER_NAME": "dotfiles-issue-123",
           "WORKSPACE_DIR": "./contexts/issue-123/workspace",
           "MEMORY_LIMIT": "2G",
           "CPU_LIMIT": "1.0"
         }
       }
     }
   }
   ```

2. **MCPサーバー再利用**
   - セッション開始時に既存MCPプロセスを確認
   - アクティブな場合は既存接続を使用
   - 非アクティブな場合は再起動

3. **リソース制限**
   - MCPサーバー環境変数で制限を設定
   - メモリ: 2GB、CPU: 1.0コア相当
   - ワークスペースはコンテキストディレクトリに限定

###### MCPサーバーライフサイクル
1. **セッション開始時**
   ```bash
   # コンテキストのMCP設定を確認
   if [ -f ".claude/contexts/${CONTEXT_ID}/mcp-config.json" ]; then
     # 既存設定でMCPサーバー起動
     claude mcp start --config ".claude/contexts/${CONTEXT_ID}/mcp-config.json"
   else
     # 新規作成
     claude mcp add container-use-${CONTEXT_ID} ...
   fi
   ```

2. **セッション終了時**
   - アクティブタスクあり: MCPサーバーは起動状態を維持
   - 全タスク完了: MCPサーバーを停止してリソース解放

3. **自動管理**
   - MCPサーバーはコンテナのライフサイクルを自動管理
   - 長期未使用時は自動的にリソースを解放
   - `.claude/contexts/*/context.json`のstatusと連動

### 作業プロセス
1. **コンテキスト確立**: 上記プロセスでコンテキストを確定してから作業開始
2. **TodoWriteで計画**: 3ステップ以上のタスクは必ずtodoリスト化
3. **単一タスク集中**: in_progressは常に1つのみ
4. **即座のステータス更新**: タスク完了時は即座に更新
5. **git操作は明示的要求時のみ**: コミット・プッシュはユーザー指示待ち

## ドキュメンテーション

### 最優先事項
1. **新規ドキュメント作成禁止**: README.md等は明示的要求時のみ作成
2. **簡潔性重視**: 必要最小限の情報で明確に伝える
3. **構造化**: 見出し、リスト、コードブロックで読みやすく整理
4. **正確性**: 技術的に正確で誤解を招かない表現

### 記述スタイル
1. **Markdown形式**: GitHub Flavored Markdownで記述
2. **コード例示**: 実行可能な具体例を含める
3. **用語統一**: プロジェクト内で使用される用語に統一
4. **バージョン明記**: ライブラリやAPIのバージョンを明確に

## 調査・分析

### 最優先事項
1. **並列検索**: 複数の独立した検索は一度に実行
2. **Taskツール活用**: キーワード検索や複雑な調査にはTaskツールを使用
3. **コンテキスト理解**: 周辺コードを十分に読み込んでから分析
4. **事実ベース**: 推測を避け、コードから読み取れる事実のみ報告

### 検索戦略
1. **Glob優先**: 特定ファイルパターンの検索にはGlobを使用
2. **Grep活用**: コード内容の検索にはGrepを使用（bash grepは使わない）
3. **ファイル参照形式**: `file_path:line_number`形式で具体的な場所を示す
4. **WebFetch/WebSearch**: 最新情報や外部リソースの確認に活用

### 報告方法
1. **4行以内の回答**: 要点のみを簡潔に（ツール使用・コード除く）
2. **直接的な回答**: 前置き・後置きを避ける
3. **具体例提示**: 抽象的な説明より具体的なコード例
4. **根拠明示**: 判断の根拠となるコードや文書を引用
