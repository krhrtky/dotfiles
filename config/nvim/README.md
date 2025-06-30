# Neovim IDE環境設定

## 実装済み高優先度機能 ✅

### 1. デバッグ機能強化
- **nvim-dap-ui**: 変数、ウォッチ、コールスタックを可視化するデバッグUI
- **nvim-dap-virtual-text**: デバッグ中の変数値をインライン表示
- **設定済みキーバインド**:
  - `F5`: デバッグ開始/継続
  - `F1`: ステップイン
  - `F2`: ステップオーバー
  - `F3`: ステップアウト
  - `<leader>b`: ブレークポイント切り替え
  - `<leader>B`: 条件付きブレークポイント設定
  - `<leader>dr`: デバッグREPLを開く
  - `<leader>dl`: 最後のデバッグセッション再実行

### 2. プロジェクト管理
- **project.nvim**: プロジェクトの自動検出と切り替え
- **telescope-project.nvim**: Telescopeとの統合によるプロジェクト切り替え
- **キーバインド**:
  - `<leader>pp`: プロジェクト間の切り替え
- **プロジェクト検出パターン**: Git、Cargo.toml、package.json、Makefileなど

### 3. ターミナル統合
- **toggleterm.nvim**: フローティング、水平、垂直ターミナル
- **キーバインド**:
  - `<C-\>`: ターミナル切り替え
  - `<leader>th`: 水平ターミナル
  - `<leader>tv`: 垂直ターミナル
  - `<leader>tf`: フローティングターミナル

### 4. テストフレームワーク統合
- **neotest**: ユニバーサルテスティングフレームワーク
- **neotest-rust**: Cargoと統合されたRustテストアダプター
- **Kotlinテストサポート**: 基本設定を追加
- **キーバインド**:
  - `<leader>tt`: 最寄りのテスト実行
  - `<leader>tf`: ファイル内全テスト実行
  - `<leader>ts`: テストサマリー切り替え
  - `<leader>to`: テスト出力表示
  - `<leader>tO`: 出力パネル切り替え
  - `<leader>tS`: テスト実行停止

## 言語固有の強化

### Rust
- lldbを使用したデバッグアダプター設定済み
- neotest-rustによるテスト統合
- テスト検出のためのCargo統合

### Kotlin
- kotlin-debug-adapterによるデバッグアダプター
- 基本的なテストフレームワーク設定
- Gradle統合準備済み

## 次のステップ（中優先度）
提案書に基づく次の実装予定機能：

1. **リファクタリングツール**
   - refactoring.nvim
   - inc-rename.nvim

2. **Git統合強化**
   - diffview.nvim
   - neogit

3. **コード品質ツール**
   - todo-comments.nvim
   - neogen
   - vim-illuminate

4. **ファイルナビゲーション**
   - flash.nvim
   - harpoon

## 設定詳細

すべての設定はlazy.nvimパターンに従って構成：
- 最適なパフォーマンスのための遅延読み込み
- 適切な場所でのキーベース読み込み
- 適切な依存関係管理
- 既存のLSPと補完設定との統合

## インストール

プラグインは次回のNeovim起動時に自動インストールされます。設定はモジュール化されており、既存の設定と競合しません。

## アーキテクチャ

### コア構造
- `init.lua` - 設定モジュールを読み込むエントリーポイント
- `lua/config/` - コア設定ファイル
  - `lazy.lua` - Lazy.nvimのブートストラップと設定
  - `options.lua` - Vimオプションと設定
  - `keymap.lua` - グローバルキーマップ
- `lua/plugins/` - カテゴリ別に整理されたプラグイン設定
  - `code.lua` - LSP、補完、診断、開発ツール
  - `ui.lua` - UI強化（neo-tree、lualine、treesitterなど）
  - `git.lua` - Git統合プラグイン
  - `colorscheme.lua` - カラースキーム設定
  - `kotlin.lua` - Kotlin言語サポート
  - `rust.lua` - Rust言語サポート
  - `spec1.lua` - 追加プラグインとユーティリティ

### 主要な設定詳細

#### LSP設定
- lsp-zero.nvim v3.xをLSP設定基盤として使用
- LSPサーバー管理にMason.nvim
- mason-lspconfig.nvimによる言語サーバー設定
- nvim-cmpとLuaSnipによる補完

#### 言語サポート
- **Kotlin**: kotlin_lsp、ktlintフォーマット/リント、kotlin-debug-adapterによるデバッグの完全設定
- **Rust**: rust-analyzer、rustfmt、clippy、lldbデバッグ、plus rust-tools.nvimとcrates.nvim
- **一般**: Lua、JavaScript、HTML、JSON、Markdownなど複数言語のTreesitterパーサー

#### UI設定
- カラースキーム: Solarized lightテーマ
- ステータスライン: solarized_lightテーマとglobalstatusを持つLualine
- ファイルエクスプローラー: Neo-tree（Ctrl+nで切り替え）
- 検索ハイライト: nvim-hlslens
- 診断表示: tiny-inline-diagnostic.nvimとtrouble.nvim

#### 開発ツール
- ファジーファインダー用Telescope（Leader+ffでファイル）
- スマートjoin/split用Treesj
- スマートインクリメント/デクリメント用Dial.nvim
- キーマップヒント用Which-key
- ブラケット補完用Autopairs

## 一般的なコマンド

### プラグイン管理
```vim
:Lazy                 " lazy.nvimインターフェース開く
:Lazy update          " 全プラグインアップデート
:Lazy sync            " 不足プラグインのインストールとアップデート
```

### LSPコマンド
```vim
:LspInfo              " LSPサーバーステータス表示
:LspInstall <server>  " LSPサーバーインストール
:Mason                " ツール管理用Masonインターフェース開く
```

### ファイルナビゲーション
- `<C-n>` - Neo-treeファイルエクスプローラー切り替え
- `<Leader>ff` - Telescopeファイル検索
- `<Leader>fp` - プラグインファイル検索

### 診断
- `<Leader>xx` - Trouble診断切り替え
- `<Leader>xX` - バッファ診断切り替え

### 開発環境セットアップ

設定で期待される環境：
- Neovim 0.8+
- プラグイン管理用Git
- 一部のLSPサーバー用Node.jsとnpm
- Masonまたはシステムパッケージマネージャーでインストールされた言語固有ツール

### カスタマイズ注意点

- リーダーキーはSpaceに設定
- ローカルリーダーはバックスラッシュ
- デフォルトで2スペースインデント
- 行番号有効
- システムクリップボード統合有効
- ライトバックグラウンドテーマ優先