local keymap = vim.keymap

vim.g.mapleader = '<Space>'
keymap.set('n', '<ESC><ESC>', ':noh<CR>')

-- 前のカーソル位置に戻る (Ctrl + o の代わり)
keymap.set('n', '<M-[>', '<C-o>', { desc = 'Jump to older position' })

-- 次のカーソル位置に進む (Ctrl + i の代わり)
keymap.set('n', '<M-]>', '<C-i>', { desc = 'Jump to newer position' })
