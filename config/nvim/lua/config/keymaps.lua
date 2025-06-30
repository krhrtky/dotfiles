-- Enhanced Keymaps for IDE-like Experience
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Better up/down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

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

-- Buffer Navigation (IDE-like)
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

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

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better indenting
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

-- Enhanced Search
keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Enhanced word search
keymap.set("n", "*", function()
  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.opt.hlsearch = true
    vim.cmd("normal! n")
  end
end, { desc = "Search word under cursor" })

keymap.set("n", "#", function()
  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.opt.hlsearch = true
    vim.cmd("normal! N")
  end
end, { desc = "Search word under cursor (reverse)" })

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

-- Join lines without space
keymap.set("n", "gJ", function()
  if vim.v.count == 0 then
    vim.cmd("normal! J")
  else
    vim.cmd("normal! " .. vim.v.count .. "J")
  end
  -- Remove the space that J adds
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col('.')
  if col > 1 and line:sub(col-1, col-1) == ' ' then
    vim.cmd("normal! x")
  end
end, { desc = "Join lines without space" })

-- Enhanced folding
keymap.set("n", "zR", "zR", { desc = "Open all folds" })
keymap.set("n", "zM", "zM", { desc = "Close all folds" })
keymap.set("n", "zr", "zr", { desc = "Open more folds" })
keymap.set("n", "zm", "zm", { desc = "Close more folds" })

-- Tab management
keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
keymap.set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<leader>tf", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap.set("n", "<leader>tl", "<cmd>tablast<cr>", { desc = "Last Tab" })

-- LSP keymaps (will be overridden by lsp-zero when available)
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

-- Diagnostic keymaps
keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })

-- Terminal
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })
keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Enhanced command-line editing
keymap.set("c", "<C-a>", "<Home>", { desc = "Go to beginning" })
keymap.set("c", "<C-e>", "<End>", { desc = "Go to end" })
keymap.set("c", "<C-h>", "<Left>", { desc = "Move left" })
keymap.set("c", "<C-l>", "<Right>", { desc = "Move right" })
keymap.set("c", "<C-b>", "<S-Left>", { desc = "Move word left" })
keymap.set("c", "<C-f>", "<S-Right>", { desc = "Move word right" })

-- IDE-like commenting (requires tpope/vim-commentary or similar)
keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- Quick macros
keymap.set("n", "Q", "@q", { desc = "Execute macro q" })
keymap.set("x", "Q", ":normal @q<CR>", { desc = "Execute macro q on selection" })

-- Enhanced visual mode
keymap.set("x", "p", '"_dP', { desc = "Paste without yanking" })

-- URLs
keymap.set("n", "gx", function()
  local url = vim.fn.expand("<cfile>")
  if url:match("^https?://") then
    vim.fn.system("open " .. url)
  else
    vim.fn.system("open https://" .. url)
  end
end, { desc = "Open URL under cursor" })

-- Text objects for entire buffer
keymap.set("o", "ae", ":<C-u>normal! ggVG<CR>", { desc = "Entire buffer" })
keymap.set("x", "ae", ":<C-u>normal! ggVG<CR>", { desc = "Entire buffer" })
keymap.set("o", "ie", ":<C-u>normal! ggVG<CR>", { desc = "Entire buffer" })
keymap.set("x", "ie", ":<C-u>normal! ggVG<CR>", { desc = "Entire buffer" })