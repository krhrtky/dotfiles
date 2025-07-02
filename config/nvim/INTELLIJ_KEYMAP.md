# IntelliJ IDEA キーマップ for Neovim

このドキュメントでは、NeovimでIntelliJ IDEAライクなキーマップを使用する方法を説明します。

## 🚀 はじめに

### 有効化
```vim
:IntellijKeymap    " IntelliJ IDEAキーマップに切り替え
:DefaultKeymap     " デフォルトキーマップに戻す
:KeymapToggle      " キーマップを切り替え
:KeymapStatus      " 現在のキーマップ状態を表示
```

### 要件
- macOS推奨（Cmdキーサポート）
- Neovim 0.8+
- 各種プラグイン（Telescope、DAP、Neotest等）

---

## 📁 ナビゲーション

### クイックナビゲーション
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+O` | ファイルに移動 | Go to File |
| `Cmd+Shift+O` | ファイル内検索 | Find in Files |
| `Cmd+E` | 最近のファイル | Recent Files |
| `Cmd+Shift+A` | アクション検索 | Find Action |

### クラス・シンボルナビゲーション
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+F12` | ファイル構造 | File Structure |
| `Cmd+Shift+F12` | シンボルに移動 | Navigate to Symbol |
| `Cmd+B` | 宣言に移動 | Go to Declaration |
| `Cmd+Shift+B` | 型宣言に移動 | Go to Type Declaration |
| `Cmd+U` | 実装に移動 | Go to Implementation |

### コードナビゲーション
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Ctrl+[` | 戻る | Navigate Back |
| `Ctrl+]` | 進む | Navigate Forward |
| `Cmd+G` | 行に移動 | Go to Line |

### 検索・置換
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+F` | 検索 | Find |
| `Cmd+R` | 置換 | Replace |
| `Cmd+Shift+F` | パス内検索 | Find in Path |
| `Cmd+Shift+R` | パス内置換 | Replace in Path |

---

## 📝 ファイル操作

### ファイル管理
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+N` | 新規ファイル | New File |
| `Cmd+S` | 保存 | Save |
| `Cmd+Shift+S` | 全て保存 | Save All |
| `Cmd+W` | タブを閉じる | Close Tab |

### プロジェクトツリー
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+1` | プロジェクトツリー | Project Tree |
| `Cmd+Shift+1` | プロジェクトで選択 | Select in Project Tree |

---

## ✏️ 編集

### コード補完・生成
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Ctrl+Space` | 基本補完 | Basic Code Completion |
| `Cmd+Enter` | コンテキストアクション | Show Context Actions |
| `Cmd+Shift+Enter` | クイックフィックス | Quick Fix |
| `Cmd+Shift+G` | パラメータ情報 | Parameter Info |

### リファクタリング
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Shift+F6` | リネーム | Rename |
| `Cmd+Shift+F6` | 使用箇所検索 | Find Usages |
| `Cmd+Shift+L` | コード整形 | Reformat Code |

### コメント
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+/` | 行コメント | Comment Line |
| `Cmd+Shift+/` | ブロックコメント | Block Comment |

### コード折り畳み
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+=` | 展開 | Expand |
| `Cmd+-` | 折り畳み | Collapse |
| `Cmd+Shift+=` | 全て展開 | Expand All |
| `Cmd+Shift+-` | 全て折り畳み | Collapse All |

---

## 📋 選択・編集

### テキスト選択
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+A` | 全選択 | Select All |
| `Cmd+Shift+W` | 単語に選択拡張 | Extend Selection to Word |

### マルチカーソル
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+D` | 次の同一選択追加 | Add Selection for Next Occurrence |
| `Cmd+Shift+D` | 全ての同一選択 | Select All Occurrences |

### 行操作
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Shift+Up` | 行を上に移動 | Move Line Up |
| `Cmd+Shift+Down` | 行を下に移動 | Move Line Down |
| `Cmd+L` | 行複製 | Duplicate Line |

### クリップボード
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+C` | コピー | Copy |
| `Cmd+X` | 切り取り | Cut |
| `Cmd+V` | 貼り付け | Paste |

### 元に戻す・やり直し
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Z` | 元に戻す | Undo |
| `Cmd+Shift+Z` | やり直し | Redo |

---

## 🪟 表示・ウィンドウ

### ツールウィンドウ
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+6` | 問題ツールウィンドウ | Problems Tool Window |
| `Cmd+9` | バージョン管理 | Version Control |

### エディタタブ
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Shift+[` | 前のタブ | Previous Tab |
| `Cmd+Shift+]` | 次のタブ | Next Tab |
| `Cmd+Shift+W` | タブを閉じる | Close Tab |

### 分割ウィンドウ
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Shift+V` | 垂直分割 | Split Vertically |
| `Cmd+Shift+H` | 水平分割 | Split Horizontally |

### フォーカス
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Shift+F12` | 全ツールウィンドウ非表示 | Hide All Tool Windows |

---

## 🔨 ビルド・実行

### ビルド
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+F9` | プロジェクトビルド | Build Project |

### 実行
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Ctrl+R` | 実行 | Run |

---

## 🐛 デバッグ

### デバッグ制御
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Shift+F9` | ブレークポイント切り替え | Toggle Breakpoint |
| `Cmd+Shift+F8` | プログラム再開 | Resume Program |
| `F8` | ステップオーバー | Step Over |
| `F7` | ステップイン | Step Into |
| `Shift+F8` | ステップアウト | Step Out |

### デバッグウィンドウ
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+5` | デバッグツールウィンドウ | Debug Tool Window |

---

## 🧪 テスト

### テスト実行
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Ctrl+Shift+R` | テスト実行 | Run Test |
| `Cmd+Shift+F10` | ファイル内テスト実行 | Run Tests in File |

---

## 🔄 Git/VCS

### バージョン管理
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+K` | VCS操作ポップアップ | VCS Operations Popup |
| `Cmd+Shift+K` | 変更をコミット | Commit Changes |

---

## 💻 ターミナル

| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+F12` | ターミナル | Terminal |

---

## ❓ ヘルプ・情報

### クイックドキュメント
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `F1` | クイックドキュメント | Quick Documentation |
| `Cmd+J` | クイックドキュメント | Quick Documentation |
| `Shift+F1` | 外部ドキュメント | External Documentation |

### パラメータ情報
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+P` | パラメータ情報 | Parameter Info |

---

## 🔧 その他

### 一般
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Q` | 終了 | Exit |
| `Cmd+,` | 設定 | Preferences |
| `Cmd+Shift+F7` | 使用箇所表示 | Find Usages |
| `Cmd+Shift+E` | 最近変更されたファイル | Recently Changed Files |

### ブックマーク
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `F11` | ブックマーク切り替え | Toggle Bookmark |
| `Cmd+F11` | ブックマーク表示 | Show Bookmarks |

### コンテキスト情報
| キー | 機能 | IntelliJ対応 |
|------|------|-------------|
| `Cmd+Shift+P` | コンテキスト情報 | Context Info |

---

## 🔄 キーマップ切り替え

### 管理コマンド
```vim
:IntellijKeymap    " IntelliJ IDEAキーマップを有効化
:DefaultKeymap     " デフォルトNeovimキーマップに戻す
:KeymapToggle      " キーマップを切り替え
:KeymapStatus      " 現在のキーマップ状態表示
```

### クイック切り替え
| キー | 機能 |
|------|------|
| `<leader>kt` | キーマップ切り替え |
| `<leader>km` | キーマップ管理メニュー |

---

## ⚠️ 注意事項

### macOS推奨
- このキーマップはmacOSのCmdキー使用を前提に設計
- Linux/WindowsではCmdキーがCtrlキーにマップされる場合がある

### 競合する可能性のあるキー
- `Cmd+D`: 行複製 vs マルチカーソル
- `Ctrl+N`: IntelliJのクラス検索 vs Neo-tree

### プラグイン依存
以下のプラグインが必要です：
- Telescope (ファイル検索・ナビゲーション)
- DAP (デバッグ)
- Neotest (テスト)
- Neo-tree (プロジェクトツリー)
- Comment.nvim (コメント)
- vim-visual-multi (マルチカーソル)

---

## 🚀 クイックスタート

1. **キーマップを有効化**:
   ```vim
   :IntellijKeymap
   ```

2. **基本的な操作を試す**:
   - `Cmd+O`: ファイルを開く
   - `Cmd+1`: プロジェクトツリー
   - `Cmd+/`: 行コメント
   - `Cmd+L`: 行複製

3. **元に戻す**:
   ```vim
   :DefaultKeymap
   ```

4. **状態確認**:
   ```vim
   :KeymapStatus
   ```

このキーマップにより、IntelliJ IDEAに慣れ親しんだ開発者がNeovimでも同様の操作感で開発を行えます。