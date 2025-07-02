# Neovim IDE環境設定ガイド

この設定は、NeovimをフルIDE級の開発環境に変えるための包括的な設定です。lazy.nvimプラグインマネージャーを使用し、高性能で拡張可能な開発環境を提供します。

## 🚀 クイックスタートガイド

### 必須要件
- Neovim 0.8+ 
- Git
- Node.js & npm (一部LSPサーバー用)
- ripgrep (高速検索用)
- make (telescope-fzf-native用)

### 基本キーマップ
- **リーダーキー**: `<Space>` (スペース)
- **ローカルリーダー**: `\` (バックスラッシュ)

### IntelliJ IDEA キーマップサポート
この設定にはIntelliJ IDEAスタイルのキーマップが組み込まれており、基本的なVim操作を保持しながらIDEライクな操作を可能にします。

#### キーマップ切り替えコマンド
```vim
:IntellijKeymap    " IntelliJ IDEAキーマップに切り替え
:DefaultKeymap     " デフォルトキーマップに戻す  
:KeymapToggle      " キーマップを切り替え
:KeymapStatus      " 現在のキーマップ状態を表示
```

#### IntelliJ主要ショートカット (ターミナル互換)
```
Ctrl+O          ファイルを開く
Ctrl+Shift+O    文字列検索
<leader>fr      最近使用したファイル
Alt+1           プロジェクトツリー表示
Ctrl+/          行コメント切り替え
<leader>ld      行の複製
Alt+↑/↓         行の移動
<leader>gd      定義へジャンプ
<leader>cu      使用箇所検索
F1              クイックドキュメント
<leader>ca      コードアクション
F2              リネーム
<leader>cf      コードフォーマット
```

#### 主要機能別ショートカット
```
# ファイル操作
Ctrl+S          保存
<leader>fn      新規ファイル
<leader>bd      バッファ閉じる

# 検索・ナビゲーション  
<leader>ff      ファイル検索
<leader>sg      文字列検索
<leader>fs      ファイル構造
<leader>ws      ワークスペースシンボル

# デバッグ・実行
F9              ビルド
F5              デバッグ開始
<leader>db      ブレークポイント切り替え
F12             ターミナル

# Git操作
<leader>gk      Git操作メニュー
<leader>gK      コミット
```

**注意**: 基本的なVim操作（hjkl, /, ?, n, N, i, a, o, d, y, p等）は保持されます。

---

## ⚙️ コア設定 (lua/config/)

### options.lua - Neovimオプション設定
Neovimデフォルトから変更されている主要設定：

#### 表示設定
- `number = true` - 行番号表示
- `background = "light"` - ライトテーマ
- `cursorline = true` - カーソル行ハイライト
- `laststatus = 3` - グローバルステータスライン

#### インデント設定 (デフォルト: 8スペースタブ)
- `tabstop = 2` - タブ幅2スペース
- `softtabstop = 2` - ソフトタブ2スペース
- `shiftwidth = 2` - 自動インデント2スペース
- `expandtab = true` - タブをスペースに変換

#### 検索設定
- `ignorecase = true` - 大文字小文字無視
- `smartcase = true` - 大文字入力時は区別

#### システム連携
- `clipboard = "unnamedplus"` - システムクリップボード連携
- `directory = "/tmp"` - スワップファイルを/tmpに配置

#### 補完設定
- `completeopt = "menuone"` - メニューのみ表示

### keymaps.lua - プラグイン専用キーマップ
**重要**: 標準Vim操作は変更せず、プラグイン機能のみ追加

#### ウィンドウ操作
- `<C-hjkl>` - ウィンドウ間移動
- `<C-arrows>` - ウィンドウサイズ変更

#### バッファ管理
- `[b` / `]b` - 前/次のバッファ
- `<leader>bb` - 直前のバッファに切り替え
- `<leader>bd` - バッファ削除（保存確認付き）

#### 高度な保存・終了
- インテリジェントな終了処理（未保存ファイル確認）
- 複数保存オプション

#### LSP統合（非競合）
- `<leader>ca` - コードアクション
- `<leader>cr` - リネーム
- `<leader>cd` - 診断表示
- `]d` / `[d` - 診断間移動

### keymap-switcher.lua - キーマップ切り替えシステム
**機能**: デフォルトとIntelliJ keymap間の動的切り替え

#### 主要機能
- バックアップ・復元システム
- 状態管理（current: default/intellij）
- コマンドとWhich-key統合

#### 利用可能コマンド
- `:KeymapToggle` - 切り替え
- `:IntellijKeymap` - IntelliJに変更
- `:DefaultKeymap` - デフォルトに戻す
- `:KeymapStatus` - 現在状態表示

### intellij-keymaps.lua - IntelliJ風ショートカット
**重要**: Vim標準操作は一切変更せず、プラグイン機能のみ提供

#### 設計原則
- 全てのVim標準操作を保持
- ターミナル互換キー組み合わせ
- プラグイン機能への直感的アクセス

### lazy.lua - プラグインマネージャー設定
- 自動ブートストラップ
- リーダーキー設定（Space / Backslash）
- 自動プラグイン更新チェック
- エラーハンドリング付きgitクローン

---

## 🔌 プラグイン設定 (lua/plugins/)

### code.lua - 開発ツール

#### LSP・補完基盤
- **lsp-zero.nvim** (v3.x) - LSP設定フレームワーク
- **mason.nvim** - LSPサーバー管理（`:Mason`）
- **nvim-lspconfig** - LSP クライアント設定
- **nvim-cmp** - 補完エンジン（`<C-Space>` 補完トリガー）
- **LuaSnip** - スニペットエンジン

#### Telescope - ファジーファインダー
**包括的検索・ナビゲーションシステム**
```bash
# ファイル・プロジェクト
<leader>ff      # find_files
<leader>fr      # 最近のファイル  
<leader>,       # バッファ切り替え
<leader>fp      # プロジェクト検索

# コード・シンボル
<leader>sg      # live_grep 文字列検索
<leader>sw      # カーソル下の単語検索
<leader>lr      # LSP参照
<leader>ld      # LSP定義

# Git統合
<leader>gc      # Gitコミット
<leader>gb      # Gitブランチ
<leader>gs      # Gitステータス
```

#### 診断・デバッグ
- **trouble.nvim** - 診断ビューア（`<leader>xx` 診断表示）
- **tiny-inline-diagnostic.nvim** - インライン診断
- **nvim-dap** - デバッグアダプタープロトコル
  - `<F5>` 実行継続 / `<F1-F3>` ステップ制御
  - `<leader>b` ブレークポイント切り替え

#### コード操作・ユーティリティ
- **treesj** - スマート結合・分割（`<leader>tj/ts/tm`）
- **dial.nvim** - 数値・日付・ブール値のインクリメント
- **nvim-autopairs** - 自動括弧ペア
- **toggleterm.nvim** - ターミナル統合（`<C-\>` トグル）
- **project.nvim** - プロジェクト検出・管理
- **neotest** - テストフレームワーク

### ui.lua - ユーザーインターフェース

#### ファイル・ナビゲーション
- **neo-tree.nvim** - ファイルエクスプローラー（`<C-n>` トグル）
- **bufferline.nvim** - 高機能バッファタブ
  - `<S-h>/<S-l>` 前/次バッファ
  - `<leader>1-9` 直接バッファアクセス
  - `<leader>bp/bc/bo` ピック・クローズ・その他クローズ

#### ステータス・表示
- **lualine.nvim** - ステータスライン（solarized_light）
- **which-key.nvim** - キーマップヒント
- **incline.nvim** - 分割ウィンドウでのファイル名表示

#### 構文・ビジュアル
- **nvim-treesitter** - 構文ハイライト（多言語対応）
- **indent-blankline.nvim** - インデントガイド・スコープ表示
- **nvim-hlslens** - 検索結果ハイライト

#### 高速ナビゲーション
- **flash.nvim** - 高度モーション
  - `s` フラッシュジャンプ / `S` treesitter
  - `r` リモート / `R` treesitter検索
- **harpoon** - ファイルマーク
  - `<leader>ha` 追加 / `<leader>hh` メニュー
  - `<leader>h1-4` マークファイル選択

### editor.lua - エディター機能拡張

#### ファイル操作
- **oil.nvim** - ディレクトリをバッファとして編集
  - `<leader>-` 親ディレクトリ / `<leader>e` 現在ディレクトリ
  - ファイル操作後 `:w` で変更反映

#### テキスト操作
- **nvim-surround** - テキスト囲み操作
  - `ys` 追加 / `ds` 削除 / `cs` 変更
  - Visual: `S` 選択範囲を囲む
- **vim-visual-multi** - マルチカーソル
  - `<C-m>` 単語選択 / `<C-Down>/<C-Up>` マルチカーソル
- **Comment.nvim** - コメント機能
  - `gcc` 行コメント / `gc` 範囲コメント / `<leader>/` トグル

#### 品質・セッション
- **nvim-bqf** - 改良quickfix（プレビュー・フィルタリング）
- **auto-session** - セッション管理
  - `<leader>Sr/Ss/Sa/Sd/Sf` 復元/保存/トグル/削除/検索
- **nvim-ufo** - 高度フォールディング（`zp` プレビュー）

### git.lua - Git統合
- **gitsigns.nvim** - Git gutter・統合
- **gitlinker.nvim** - Git リンク生成
  - `<leader>gy` リンクヤンク / `<leader>gY` リンクオープン

### colorscheme.lua - カラーテーマ
- **solarized.nvim** - Solarized Light テーマ（高優先度読み込み）

### 言語サポート

#### kotlin.lua - Kotlin開発
- **kotlin_lsp** - 言語サーバー
- **ktlint** - フォーマット・リント（Mason経由）
- **detekt** - 追加リント
- **kotlin-debug-adapter** - デバッグサポート
- **neotest-kotlin** - テストアダプター（Gradle・JUnit5）

#### rust.lua - Rust開発  
- **rust-analyzer** - 包括的LSP設定
  - Cargo機能・ビルドスクリプト・clippyサポート
- **rust-tools.nvim** - Rust特化ツール
  - `<C-space>` ホバーアクション / `<Leader>a` コードアクション
- **crates.nvim** - Cargo依存関係管理
- **lldb** - デバッガーアダプター

### spec1.lua - 追加ユーティリティ
- **neorg** - ノート・組織化（.norgファイル）
- **vim-startuptime** - 起動時間分析（`StartupTime`）
- **dressing.nvim** - UI コンポーネント強化
- **noice.nvim** - 通知UI改善

---

## 📊 設定サマリー

### デフォルトからの主要変更点
1. **インデント**: 8スペースタブ → 2スペース
2. **テーマ**: ダーク → ライト（Solarized Light）
3. **ステータス**: ウィンドウ毎 → グローバルステータスライン
4. **クリップボード**: Vim内部のみ → システム連携
5. **補完**: 複数オプション → メニューのみ表示
6. **スワップファイル**: カレントディレクトリ → /tmp配置

### キーマップ設計思想
- **標準Vim操作**: 完全保持（hjkl, /, ?, n, N, i, a, o, d, y, p等）
- **プラグイン操作**: `<leader>`、`<C-*>`、`<F*>`、`]`/`[`プレフィックス使用
- **IntelliJ互換**: 追加レイヤーとして提供、標準操作を上書きしない
- **ターミナル互換**: 全ショートカットがターミナルで動作

### プラグイン構成
- **総プラグイン数**: 約40個
- **LSP対応言語**: Kotlin、Rust、JavaScript、TypeScript、Lua、Python等
- **UI強化**: ファイルエクスプローラー、ステータスライン、バッファタブ
- **開発支援**: 診断、デバッグ、テスト、Git統合
- **ナビゲーション**: ファジーファインダー、高速ジャンプ、ファイルマーク

---

## 📁 ファイル操作 & ナビゲーション

### Neo-tree (ファイルエクスプローラー)
```
<C-n>           ファイルツリー開閉 (最優先キー)
```

### Oil.nvim (ディレクトリエディタ)
```
<leader>e       現在ディレクトリをエディタで開く
<leader>-       親ディレクトリをエディタで開く
```
- ファイルを直接編集するように操作
- `:w` で変更をファイルシステムに反映

### Telescope (ファジーファインダー)

#### ファイル検索
```
<leader>ff      ファイル検索
<leader>fF      隠しファイル含む全ファイル検索
<leader>fr      最近使用したファイル
<leader>fb      ファイルブラウザー
<leader>fB      現在ディレクトリのファイルブラウザー
<leader>fp      プラグインファイル検索
```

#### 検索操作
```
<leader>sg      Live Grep (文字列検索)
<leader>sG      Live Grep with Args (高度な検索)
<leader>sw      カーソル下の単語検索
<leader>sb      バッファ内検索
<leader>sc      コマンド履歴
<leader>sh      ヘルプタグ
<leader>sm      マニュアルページ
<leader>sk      キーマップ一覧
<leader>ss      Telescope機能選択
<leader>sr      最後の検索を再開
```

#### Telescope内操作
```
<C-j>/<C-k>     選択移動
<C-p>           履歴戻る
<C-x>           水平分割で開く
<C-v>           垂直分割で開く
<C-t>           新しいタブで開く
<C-q>           クイックフィックスリストに送信
<Tab>           複数選択
```

---

## 🗂️ バッファ管理

### Bufferline (タブ表示)
```
<S-h>           前のバッファ
<S-l>           次のバッファ
<leader>1-9     バッファ番号で直接移動
<leader>bp      バッファピッカー (選択)
<leader>bc      選択してバッファ削除
<leader>bo      他の全バッファを削除
<leader>br      右側のバッファを削除
<leader>bl      左側のバッファを削除
```

### バッファ操作
```
<leader>,       バッファスイッチャー (MRU順)
<leader>;       全バッファ一覧
<leader>bb      前のバッファに切り替え
<leader>`       前のバッファに切り替え (代替)
<leader>bd      バッファ削除 (安全確認付き)
<leader>bD      強制バッファ削除
<leader>bw      バッファワイプアウト
<leader>bO      他のバッファを全て削除
```

---

## ⚡ 高速ナビゲーション

### Flash.nvim (画面内ジャンプ)
```
s               画面内任意の場所にジャンプ
S               Treesitterノードにジャンプ
r               リモートオペレーション用
R               Treesitter検索
<C-s>           コマンドラインでFlash切り替え
```

### Harpoon (ファイルマーク)
```
<leader>ha      現在のファイルをマーク追加
<leader>hh      マークファイル一覧表示
<leader>h1-4    マークファイル1-4に移動
```

---

## 🔍 コード編集

### マルチカーソル (vim-visual-multi)
```
<C-m>           カーソル下の単語を選択/次を追加
<leader>m       マルチカーソル選択 (代替)
<C-Down>        下にカーソル追加
<C-Up>          上にカーソル追加
<C-S-m>         全ての一致を選択
```

### テキスト操作 (nvim-surround)
```
ys{motion}{char}    囲み文字追加 (例: ysiw" で単語を"で囲む)
cs{old}{new}        囲み文字変更 (例: cs"' で"を'に変更)
ds{char}            囲み文字削除 (例: ds" で"を削除)
S{char}             ビジュアル選択を囲む
```

### コメント (Comment.nvim)
```
gcc             現在行コメント切り替え
gc{motion}      指定範囲コメント切り替え
gbc             ブロックコメント切り替え
<leader>/       コメント切り替え (ノーマル/ビジュアル)
```

### TreeSJ (構造操作)
```
<leader>tj      join/split切り替え
<leader>ts      構造を分割
<leader>tm      構造を結合
```

### 折り畳み (nvim-ufo)
```
zR              全ての折り畳みを開く
zM              全ての折り畳みを閉じる
zr              より多くの折り畳みを開く
zm              より多くの折り畳みを閉じる
zp              折り畳みをプレビュー
```

---

## 🐛 デバッグ

### DAP (Debug Adapter Protocol)
```
<F5>            デバッグ開始/継続
<F1>            ステップイン
<F2>            ステップオーバー
<F3>            ステップアウト
<leader>b       ブレークポイント切り替え
<leader>B       条件付きブレークポイント
<leader>dr      デバッグREPL開く
<leader>dl      最後のデバッグセッション再実行
```

---

## 🧪 テスト (Neotest)

```
<leader>tt      最寄りのテスト実行
<leader>tf      ファイル内全テスト実行
<leader>ts      テストサマリー切り替え
<leader>to      テスト出力表示
<leader>tO      テスト出力パネル切り替え
<leader>tS      実行中のテスト停止
```

---

## 💻 ターミナル (ToggleTerm)

```
<C-\>           ターミナル切り替え
<leader>th      水平ターミナル
<leader>tv      垂直ターミナル
<leader>tf      フローティングターミナル
```

### ターミナル内操作
```
<Esc><Esc>      ノーマルモードに戻る
<C-h/j/k/l>     ウィンドウ移動
```

---

## 🔧 LSP & 開発ツール

### LSP操作
```
gd              定義へ移動
gr              参照一覧
gI              実装へ移動
gy              型定義へ移動
gD              宣言へ移動
K               ホバー情報
gK              シグネチャヘルプ
<C-k>           シグネチャヘルプ (挿入モード)
<leader>ca      コードアクション
<leader>cr      リネーム
```

### Telescope LSP統合
```
<leader>lr      LSP参照
<leader>ld      LSP定義
<leader>li      LSP実装
<leader>lt      LSP型定義
<leader>ls      ドキュメントシンボル
<leader>lS      ワークスペースシンボル
```

### 診断
```
<leader>cd      行診断表示
]d              次の診断
[d              前の診断
<leader>xx      診断一覧 (Trouble)
<leader>xX      バッファ診断 (Trouble)
```

---

## 📂 プロジェクト管理

```
<leader>pp      プロジェクト切り替え
```

### セッション管理 (auto-session)
```
<leader>Sr      セッション復元
<leader>Ss      セッション保存
<leader>Sa      自動保存切り替え
<leader>Sd      セッション削除
<leader>Sf      セッション検索
```

---

## 📝 ファイル & エディタ操作

### 保存・終了
```
<C-s>           ファイル保存
<leader>w       ファイル保存
<leader>W       全ファイル保存
<leader>q       終了 (未保存確認付き)
<leader>Q       強制終了
```

### クリップボード
```
<leader>y       システムクリップボードにヤンク
<leader>Y       行をシステムクリップボードにヤンク
<leader>p       システムクリップボードからペースト
<leader>P       システムクリップボードから前にペースト
```

### 行操作
```
<leader>lm      行を上に移動
<leader>ln      行を下に移動
<leader>ld      行を複製
```

### ウィンドウ操作
```
<C-h/j/k/l>     ウィンドウ間移動
<C-Up/Down>     ウィンドウ高さ調整
<C-Left/Right>  ウィンドウ幅調整
```

### タブ管理
```
<leader>tn      新しいタブ
<leader>tc      タブを閉じる
<leader>to      他のタブを閉じる
[t              前のタブ
]t              次のタブ
<leader>tf      最初のタブ
<leader>tl      最後のタブ
```

---

## 🔄 Git統合

```
<leader>gc      Git コミット一覧
<leader>gb      Git ブランチ一覧  
<leader>gs      Git ステータス
<leader>gf      Git ファイル一覧
```

---

## 🔍 検索・置換

### 検索強化
```
*               カーソル下の単語を検索
#               カーソル下の単語を逆方向検索
n               次の検索結果 (自動中央配置)
N               前の検索結果 (自動中央配置)
<Esc>           検索ハイライト解除
```

### QuickFix/Location List
```
<leader>xq      QuickFixリスト開く
<leader>xl      Locationリスト開く
]q              次のQuickFix項目
[q              前のQuickFix項目
]l              次のLocation項目
[l              前のLocation項目
```

---

## 🎛️ 設定・ヘルプ

### プラグイン管理
```
<leader>L       Lazy.nvim管理画面
:Lazy           Lazy.nvim管理画面
:Lazy update    プラグイン更新
:Lazy sync      プラグイン同期
```

### ヘルプ・情報
```
<leader>?       which-key ヘルプ
:LspInfo        LSP情報
:Mason          Mason管理画面
```

---

## 🧰 高度な機能

### Dial.nvim (インクリメント)
```
<C-a>           数値・日付・boolean等をインクリメント
<C-x>           数値・日付・boolean等をデクリメント
```

### URL操作
```
gx              カーソル下のURLをブラウザで開く
```

### マクロ
```
Q               @q マクロを実行
```

---

## 🎨 UI & 表示

### インデント表示
- `indent-blankline.nvim`で自動的にインデントガイドを表示

### バッファライン
- ファイルタイプアイコン付きのタブ表示
- 診断情報の表示
- Neo-tree使用時は自動オフセット

### ステータスライン (Lualine)
- Solarized lightテーマ
- グローバルステータス表示

---

## 📚 言語固有サポート

### Rust
- rust-analyzer LSP
- Cargo統合
- lldb デバッグ
- neotest-rust テスト統合
- crates.nvim 依存関係管理

### Kotlin  
- kotlin_lsp LSP
- ktlint フォーマット・リント
- kotlin-debug-adapter デバッグ
- Gradle統合

### 共通
- TreeSitter シンタックスハイライト
- 自動補完 (nvim-cmp + LuaSnip)
- 自動ペア (nvim-autopairs)

---

## ⚙️ カスタマイズ

### 設定ファイル構造
```
init.lua                    # エントリーポイント
lua/config/
  ├── options.lua           # Vim オプション
  ├── keymap.lua            # 基本キーマップ
  ├── keymaps.lua           # 拡張キーマップ
  └── lazy.lua              # プラグインマネージャー
lua/plugins/
  ├── code.lua              # LSP・開発ツール
  ├── ui.lua                # UI強化
  ├── editor.lua            # エディタ機能
  ├── git.lua               # Git統合
  ├── colorscheme.lua       # カラースキーム
  ├── kotlin.lua            # Kotlin言語サポート
  └── rust.lua              # Rust言語サポート
```

### 主要設定
- **カラースキーム**: Solarized light
- **インデント**: 2スペース
- **行番号**: 有効
- **クリップボード**: システム統合
- **折り畳み**: UFO使用、レベル99

---

## 🚨 トラブルシューティング

### キーマップ競合
- `<C-n>`: Neo-tree が最優先
- マルチカーソル: `<C-m>` または `<leader>m` を使用
- TreeSJ: `<leader>tj/ts/tm` を使用

### パフォーマンス
- プラグインは遅延読み込み設定済み
- 起動時間を確認: `:Lazy profile`

### デバッグ
- LSP問題: `:LspInfo` で確認
- プラグイン問題: `:Lazy health` でヘルスチェック

---

## 💡 使用のコツ

1. **which-key**を活用: `<leader>` 押下後に待機でヘルプ表示
2. **Telescope**を多用: `<leader>ss` で機能一覧
3. **Flash**で高速移動: `s` + 2文字で画面内どこでも
4. **Harpoon**でファイル管理: よく使うファイルをマーク
5. **マルチカーソル**で効率編集: `<C-m>` で選択拡張

この設定により、NeovimがVSCodeやIntelliJ並みの機能豊富なIDEとして動作します。すべての機能は段階的に学習でき、必要に応じて使い分けることができます。