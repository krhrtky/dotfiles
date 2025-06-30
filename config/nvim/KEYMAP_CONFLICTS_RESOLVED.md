# キーマップ競合解決レポート

## 解決済み競合

### `<C-n>` キーマップ競合

**問題**: Neo-tree (`<C-n>`) とvim-visual-multi (`<C-n>`) が同じキーを使用

**解決策**:
- **Neo-tree**: `<C-n>` を優先（ファイルツリーの開閉）
- **vim-visual-multi**: `<C-m>` + `<leader>m` に変更

### `<space>m` キーマップ競合

**問題**: treesj (`<space>m`) とマルチカーソル (`<leader>m`) の潜在的競合

**解決策**:
- **treesj**: `<leader>tj/ts/tm` に変更して明確化

## 現在のキーマップ割り当て

### ファイル操作
- `<C-n>`: Neo-tree ファイルツリー開閉 ✅
- `<leader>e`: Oil.nvim ファイルエクスプローラー
- `<leader>-`: Oil.nvim 親ディレクトリ

### マルチカーソル操作
- `<C-m>`: マルチカーソル選択 ✅ 
- `<leader>m`: マルチカーソル選択（代替）✅
- `<C-Down>/<C-Up>`: マルチカーソル上下
- `<C-S-m>`: 全選択

### TreeSJ（構造操作）
- `<leader>tj`: Toggle join/split ✅
- `<leader>ts`: Split ✅  
- `<leader>tm`: Join ✅

### Telescope（検索）
- Telescope内の `<C-n>` は無効化済み ✅
- `<C-p>`: 履歴前へ（Telescope内）
- `<C-j>/<C-k>`: 選択移動（Telescope内）

## 優先順位設定

1. **最高優先**: Neo-tree (`<C-n>`) - ファイルツリーアクセス
2. **高優先**: マルチカーソル (`<C-m>`, `<leader>m`)
3. **中優先**: TreeSJ (`<leader>t*`)
4. **基本**: Telescope内ナビゲーション

## 確認事項

✅ Neo-tree `<C-n>` が正常動作  
✅ マルチカーソル `<C-m>` に移行完了  
✅ TreeSJ `<leader>t*` キーマップに統一  
✅ Telescope内競合解消  
✅ 設定ファイル構文エラーなし

## ユーザーへの影響

### 変更が必要な操作
- **マルチカーソル**: `<C-n>` → `<C-m>` または `<leader>m`
- **TreeSJ**: `<space>m/j/s` → `<leader>tj/ts/tm`

### 変更不要な操作  
- **Neo-tree**: `<C-n>` のまま使用可能
- **Telescope**: 既存のキーマップ継続使用
- **その他のプラグイン**: 影響なし

競合が完全に解決され、Neo-treeの`<C-n>`が最優先で動作します。