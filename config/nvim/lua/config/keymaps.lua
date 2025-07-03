-- Plugin-specific Keymaps (Neovim Standard Compliant)
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- NOTE: Basic Vim/Neovim operations (j, k, h, l, /, ?, n, N, *, #, etc.) remain unchanged

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffer Navigation (Plugin-specific only)
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Buffer Management
keymap.set("n", "<leader>bd", function()
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  local modified = vim.api.nvim_buf_get_option(buf, "modified")
  
  if modified then
    local choice = vim.fn.confirm(
      "Buffer has unsaved changes. Save before closing?",
      "&Save\n&Discard\n&Cancel",
      1
    )
    if choice == 1 then
      vim.cmd("write")
      vim.cmd("bdelete")
    elseif choice == 2 then
      vim.cmd("bdelete!")
    end
  else
    vim.cmd("bdelete")
  end
end, { desc = "Delete Buffer" })

keymap.set("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force Delete Buffer" })
keymap.set("n", "<leader>bw", "<cmd>bwipeout<cr>", { desc = "Wipeout Buffer" })

-- Close all buffers except current
keymap.set("n", "<leader>bO", function()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  
  for _, buf in ipairs(buffers) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      local modified = vim.api.nvim_buf_get_option(buf, "modified")
      if not modified then
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end
end, { desc = "Close Other Buffers" })

-- Save and Quit
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
keymap.set("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save All" })
keymap.set("n", "<leader>q", function()
  -- Check if there are unsaved buffers
  local unsaved = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "modified") then
      table.insert(unsaved, vim.api.nvim_buf_get_name(buf))
    end
  end
  
  if #unsaved > 0 then
    local choice = vim.fn.confirm(
      #unsaved .. " buffer(s) have unsaved changes. Save all before quitting?",
      "&Save All\n&Discard\n&Cancel",
      1
    )
    if choice == 1 then
      vim.cmd("wa")
      vim.cmd("qa")
    elseif choice == 2 then
      vim.cmd("qa!")
    end
  else
    vim.cmd("qa")
  end
end, { desc = "Quit All" })

keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit All (Force)" })

-- Better indenting (keep selected after indent)
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Lazy
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Location and Quickfix lists
keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
keymap.set("n", "[l", vim.cmd.lprev, { desc = "Previous location" })
keymap.set("n", "]l", vim.cmd.lnext, { desc = "Next location" })

-- NOTE: Search operations (/, ?, n, N, *, #) use Neovim standard behavior

-- Enhanced text editing
keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap.set("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap.set("n", "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- Line operations
keymap.set("n", "<leader>lm", ":move .-2<CR>==", { desc = "Move line up" })
keymap.set("n", "<leader>ln", ":move .+1<CR>==", { desc = "Move line down" })
keymap.set("v", "<leader>lm", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
keymap.set("v", "<leader>ln", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Duplicate lines/selections
keymap.set("n", "<leader>ld", ":copy .<CR>", { desc = "Duplicate line" })
keymap.set("v", "<leader>ld", ":copy '><CR>gv", { desc = "Duplicate selection" })

-- NOTE: Folding operations (z commands) use Neovim standard behavior

-- Tab management
keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
keymap.set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<leader>tf", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap.set("n", "<leader>tl", "<cmd>tablast<cr>", { desc = "Last Tab" })

-- LSP keymaps (Plugin-specific, non-conflicting with standard Vim)
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })

-- NOTE: Standard LSP mappings (gd, gr, gI, gy, gD, K, etc.) use Neovim/LSP defaults

-- Terminal
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })
keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Plugin-specific commenting (requires tpope/vim-commentary or similar)
keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- Barbar keymaps
keymap.set("n", "<leader>bp", "<cmd>BufferPick<cr>", { desc = "Pick Buffer" })
keymap.set("n", "<leader>bc", "<cmd>BufferPickDelete<cr>", { desc = "Pick Close Buffer" })
keymap.set("n", "<leader>bo", "<cmd>BufferCloseAllButCurrent<cr>", { desc = "Close Other Buffers" })
keymap.set("n", "<leader>br", "<cmd>BufferCloseBuffersRight<cr>", { desc = "Close Buffers to Right" })
keymap.set("n", "<leader>bl", "<cmd>BufferCloseBuffersLeft<cr>", { desc = "Close Buffers to Left" })
keymap.set("n", "<S-h>", "<cmd>BufferPrevious<cr>", { desc = "Previous Buffer" })
keymap.set("n", "<S-l>", "<cmd>BufferNext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>1", "<cmd>BufferGoto 1<cr>", { desc = "Go to Buffer 1" })
keymap.set("n", "<leader>2", "<cmd>BufferGoto 2<cr>", { desc = "Go to Buffer 2" })
keymap.set("n", "<leader>3", "<cmd>BufferGoto 3<cr>", { desc = "Go to Buffer 3" })
keymap.set("n", "<leader>4", "<cmd>BufferGoto 4<cr>", { desc = "Go to Buffer 4" })
keymap.set("n", "<leader>5", "<cmd>BufferGoto 5<cr>", { desc = "Go to Buffer 5" })
keymap.set("n", "<leader>6", "<cmd>BufferGoto 6<cr>", { desc = "Go to Buffer 6" })
keymap.set("n", "<leader>7", "<cmd>BufferGoto 7<cr>", { desc = "Go to Buffer 7" })
keymap.set("n", "<leader>8", "<cmd>BufferGoto 8<cr>", { desc = "Go to Buffer 8" })
keymap.set("n", "<leader>9", "<cmd>BufferGoto 9<cr>", { desc = "Go to Buffer 9" })

-- NOTE: Standard Vim operations preserved:
-- - Q (Ex mode) remains standard
-- - p/P (paste) use standard behavior  
-- - gx uses standard netrw behavior
-- - Text objects (aw, iw, ap, ip, etc.) remain standard
