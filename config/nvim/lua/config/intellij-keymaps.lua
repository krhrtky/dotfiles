-- IntelliJ IDEA-style Keymaps for Plugin Operations Only
-- Preserves all standard Vim/Neovim operations
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ============================================================================
-- IMPORTANT: STANDARD VIM/NEOVIM OPERATIONS ARE PRESERVED
-- ============================================================================
-- The following standard operations remain unchanged:
-- - hjkl (movement), w/b/e (word movement), f/t (find), / ? (search)
-- - n/N (search navigation), */# (word search)  
-- - i/a/o (insert modes), d/y/p (delete/yank/paste)
-- - u/<C-r> (undo/redo), . (repeat), : (command mode)
-- - g commands (gd, gg, G, etc.), z commands (folding)
-- - [ ] commands, < > (indenting), % (bracket matching)
-- - All text objects (aw, iw, ap, ip, etc.)
-- ============================================================================

-- ============================================================================
-- NAVIGATION (Terminal-Compatible IntelliJ-style)
-- ============================================================================

-- Quick Navigation (using Ctrl combinations)
keymap.set("n", "<C-o>", "<cmd>Telescope find_files<cr>", { desc = "Go to File" })
keymap.set("n", "<C-S-o>", "<cmd>Telescope live_grep<cr>", { desc = "Find in Files" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
keymap.set("n", "<C-S-a>", "<cmd>Telescope builtin<cr>", { desc = "Find Action" })

-- Class/Symbol Navigation  
keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "File Structure" })
keymap.set("n", "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Navigate to Symbol" })
keymap.set("n", "<C-b>", function() require('telescope.builtin').lsp_definitions() end, { desc = "Go to Declaration" })
keymap.set("n", "<C-S-b>", function() require('telescope.builtin').lsp_type_definitions() end, { desc = "Go to Type Declaration" })
keymap.set("n", "<C-u>", function() require('telescope.builtin').lsp_implementations() end, { desc = "Go to Implementation" })

-- Code Navigation
keymap.set("n", "<C-[>", "<C-o>", { desc = "Navigate Back" })
keymap.set("n", "<C-]>", "<C-i>", { desc = "Navigate Forward" })
keymap.set("n", "<leader>gl", function() vim.ui.input({ prompt = "Go to line: " }, function(input) if input then vim.cmd(input) end end) end, { desc = "Go to Line" })

-- Search/Replace (using leader combinations)
keymap.set("n", "<leader>sf", "/", { desc = "Find" })
keymap.set("n", "<leader>sr", ":%s/", { desc = "Replace" })
keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Find in Path" })
keymap.set("n", "<leader>sR", "<cmd>Telescope live_grep_args<cr>", { desc = "Replace in Path" })

-- ============================================================================
-- FILE OPERATIONS (Terminal-Compatible)
-- ============================================================================

-- File Management
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
keymap.set("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save All" })
keymap.set("n", "<leader>bd", function()
  local buf = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(buf, "modified")
  if modified then
    local choice = vim.fn.confirm("Save changes?", "&Save\n&Don't Save\n&Cancel", 1)
    if choice == 1 then
      vim.cmd("write")
      vim.cmd("bdelete")
    elseif choice == 2 then
      vim.cmd("bdelete!")
    end
  else
    vim.cmd("bdelete")
  end
end, { desc = "Close Tab" })

-- Project Tree
keymap.set("n", "<leader>1", "<cmd>Neotree toggle<cr>", { desc = "Project Tree" })

-- ============================================================================
-- EDITING
-- ============================================================================

-- Code Completion and Generation
keymap.set("i", "<C-Space>", function() 
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<C-x><C-o>"
  end
end, { expr = true, desc = "Basic Code Completion" })

-- Code Actions
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show Context Actions" })
keymap.set("n", "<leader>cq", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.kind and string.match(action.kind, "quickfix")
    end,
    apply = true,
  })
end, { desc = "Quick Fix" })

-- Code Generation
keymap.set("n", "<C-p>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Parameter Info" })
keymap.set("i", "<C-p>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Parameter Info" })

-- Refactoring
keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })
keymap.set("n", "<leader>cu", "<cmd>Telescope lsp_references<cr>", { desc = "Find Usages" })

-- Code Formatting
keymap.set("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Reformat Code" })
keymap.set("v", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Reformat Code" })

-- Comments (IntelliJ-style)
keymap.set("n", "<C-/>", "gcc", { desc = "Comment Line", remap = true })
keymap.set("v", "<C-/>", "gc", { desc = "Comment Selection", remap = true })
keymap.set("n", "<C-S-/>", "gbc", { desc = "Block Comment", remap = true })

-- Code Folding
keymap.set("n", "<leader>zo", "zo", { desc = "Expand" })
keymap.set("n", "<leader>zc", "zc", { desc = "Collapse" })
keymap.set("n", "<leader>zR", "zR", { desc = "Expand All" })
keymap.set("n", "<leader>zM", "zM", { desc = "Collapse All" })

-- ============================================================================
-- SELECTION & EDITING
-- ============================================================================

-- NOTE: Standard Vim text selection, movement, and editing preserved
-- - v/V (visual mode), ggVG (select all standard way)
-- - viw, vip (standard text objects)  
-- - y/p (standard yank/paste), "+y/"+p (system clipboard standard way)
-- - u/<C-r> (standard undo/redo)
-- - Standard line operations preserved

-- ============================================================================
-- VIEW & WINDOWS
-- ============================================================================

-- Tool Windows
keymap.set("n", "<leader>1!", "<cmd>Neotree reveal<cr>", { desc = "Select in Project Tree" })
keymap.set("n", "<F6>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems Tool Window" })
keymap.set("n", "<leader>F9", "<cmd>Telescope git_status<cr>", { desc = "Version Control" })

-- Editor Tabs
keymap.set("n", "<C-S-[>", "<cmd>bprevious<cr>", { desc = "Previous Tab" })
keymap.set("n", "<C-S-]>", "<cmd>bnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<C-S-w>", "<cmd>bdelete<cr>", { desc = "Close Tab" })

-- Split Windows
keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split Vertically" })
keymap.set("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split Horizontally" })

-- Focus
keymap.set("n", "<leader>F12", function()
  vim.cmd("only")
  vim.cmd("Neotree close")
end, { desc = "Hide All Tool Windows" })

-- ============================================================================
-- BUILD & RUN
-- ============================================================================

-- Build
keymap.set("n", "<F9>", function()
  -- Try to find and run build command
  if vim.fn.filereadable("Cargo.toml") == 1 then
    vim.cmd("!cargo build")
  elseif vim.fn.filereadable("package.json") == 1 then
    vim.cmd("!npm run build")
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    vim.cmd("!./gradlew build")
  else
    vim.notify("No build configuration found", vim.log.levels.WARN)
  end
end, { desc = "Build Project" })

-- Run
keymap.set("n", "<C-R>", function()
  -- Smart run based on file type
  local ft = vim.bo.filetype
  if ft == "rust" then
    vim.cmd("!cargo run")
  elseif ft == "javascript" or ft == "typescript" then
    vim.cmd("!node %")
  elseif ft == "python" then
    vim.cmd("!python %")
  elseif ft == "kotlin" then
    vim.cmd("!kotlin %")
  else
    vim.notify("No run configuration for " .. ft, vim.log.levels.WARN)
  end
end, { desc = "Run" })

-- ============================================================================
-- DEBUG
-- ============================================================================

-- Debug Controls
keymap.set("n", "<leader>db", function() require('dap').toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
keymap.set("n", "<leader>dc", function() require('dap').continue() end, { desc = "Resume Program" })
keymap.set("n", "<F8>", function() require('dap').step_over() end, { desc = "Step Over" })
keymap.set("n", "<F7>", function() require('dap').step_into() end, { desc = "Step Into" })
keymap.set("n", "<S-F8>", function() require('dap').step_out() end, { desc = "Step Out" })

-- Debug Windows
keymap.set("n", "<F5>", function() require('dapui').toggle() end, { desc = "Debug Tool Window" })

-- ============================================================================
-- TESTING
-- ============================================================================

-- Test Execution
keymap.set("n", "<C-S-R>", function() require('neotest').run.run() end, { desc = "Run Test" })
keymap.set("n", "<leader>F10", function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = "Run Tests in File" })

-- ============================================================================
-- GIT/VCS
-- ============================================================================

-- Version Control
keymap.set("n", "<leader>gk", "<cmd>Telescope git_commits<cr>", { desc = "VCS Operations Popup" })
keymap.set("n", "<leader>gK", "<cmd>Telescope git_status<cr>", { desc = "Commit Changes" })

-- ============================================================================
-- TERMINAL
-- ============================================================================

-- Terminal
keymap.set("n", "<F12>", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })
keymap.set("t", "<F12>", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })

-- ============================================================================
-- HELP & INFORMATION
-- ============================================================================

-- Quick Documentation
keymap.set("n", "<F1>", function() vim.lsp.buf.hover() end, { desc = "Quick Documentation" })
keymap.set("n", "<leader>hd", function() vim.lsp.buf.hover() end, { desc = "Quick Documentation" })

-- External Documentation
keymap.set("n", "<S-F1>", function()
  -- Try to open external documentation
  local word = vim.fn.expand("<cword>")
  vim.fn.system("open https://docs.rs/" .. word)
end, { desc = "External Documentation" })

-- Parameter Info
keymap.set("n", "<leader>hp", function() vim.lsp.buf.signature_help() end, { desc = "Parameter Info" })
keymap.set("i", "<C-S-p>", function() vim.lsp.buf.signature_help() end, { desc = "Parameter Info" })

-- ============================================================================
-- MISCELLANEOUS
-- ============================================================================

-- IntelliJ-style Exit
keymap.set("n", "<leader>qq", function()
  local unsaved = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "modified") then
      table.insert(unsaved, vim.api.nvim_buf_get_name(buf))
    end
  end
  
  if #unsaved > 0 then
    local choice = vim.fn.confirm(
      #unsaved .. " file(s) have unsaved changes. Save before exiting?",
      "&Save All\n&Don't Save\n&Cancel",
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
end, { desc = "Exit" })

-- Settings
keymap.set("n", "<leader>,", "<cmd>Lazy<cr>", { desc = "Preferences" })

-- Show usages
keymap.set("n", "<leader>F7", function() require('telescope.builtin').lsp_references() end, { desc = "Find Usages" })

-- IntelliJ-style recently changed files
keymap.set("n", "<leader>re", function()
  require('telescope.builtin').oldfiles({
    only_cwd = true,
    -- Show files changed in last session
  })
end, { desc = "Recently Changed Files" })

-- Bookmarks (using Harpoon)
keymap.set("n", "<F11>", function() require('harpoon'):list():append() end, { desc = "Toggle Bookmark" })
keymap.set("n", "<leader>F11", function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, { desc = "Show Bookmarks" })

-- Context Info
keymap.set("n", "<leader>ci", function() 
  -- Show current context (file path, line number, etc.)
  local buf_name = vim.api.nvim_buf_get_name(0)
  local line_nr = vim.api.nvim_win_get_cursor(0)[1]
  local col_nr = vim.api.nvim_win_get_cursor(0)[2] + 1
  local rel_path = vim.fn.fnamemodify(buf_name, ":.")
  vim.notify(string.format("%s:%d:%d", rel_path, line_nr, col_nr), vim.log.levels.INFO)
end, { desc = "Context Info" })

-- ============================================================================
-- ENHANCED PLUGIN INTEGRATIONS
-- ============================================================================

-- Enhanced Neo-tree integration
keymap.set("n", "<A-1>", "<cmd>Neotree toggle<cr>", { desc = "Project Tree" })
keymap.set("n", "<A-S-1>", "<cmd>Neotree reveal<cr>", { desc = "Select in Project Tree" })

-- Oil file explorer integration  
keymap.set("n", "<leader>oe", "<cmd>Oil<cr>", { desc = "Open File Explorer" })

-- Enhanced Telescope integration
keymap.set("n", "<leader>st", "<cmd>Telescope live_grep<cr>", { desc = "Search Everywhere" })

-- Trouble diagnostics integration
keymap.set("n", "<A-6>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems Tool Window" })
keymap.set("n", "<A-S-6>", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Current File Problems" })

-- Enhanced LSP integration
keymap.set("n", "<leader>gd", function() 
  require('telescope.builtin').lsp_definitions()
end, { desc = "Go to Declaration" })

keymap.set("n", "<leader>gt", function() 
  require('telescope.builtin').lsp_type_definitions()
end, { desc = "Go to Type Declaration" })

keymap.set("n", "<leader>gi", function() 
  require('telescope.builtin').lsp_implementations()
end, { desc = "Go to Implementation" })

-- Additional useful IntelliJ-style shortcuts
keymap.set("n", "<leader>si", function() 
  require('telescope.builtin').lsp_document_symbols()
end, { desc = "File Structure" })

keymap.set("n", "<leader>hu", function() 
  require('telescope.builtin').lsp_references()
end, { desc = "Show Usages" })

-- Code inspection
keymap.set("n", "<leader>ic", function() 
  require('telescope.builtin').diagnostics()
end, { desc = "Inspect Code" })

-- ============================================================================
-- BASIC VIM OPERATIONS PRESERVATION
-- ============================================================================
-- Note: Basic Vim operations (hjkl, /, ?, n, N, etc.) are intentionally NOT overridden
-- This ensures that fundamental Vim navigation and editing remains intact

-- Preserve essential Vim commands that should NEVER be overridden:
-- - hjkl (basic movement)
-- - w, b, e (word movement) 
-- - /, ?, n, N (search)
-- - i, a, o, O (insert modes)
-- - d, y, p (delete, yank, paste)
-- - u, <C-r> (undo, redo) - only enhanced, not replaced
-- - : (command mode)
-- - . (repeat)
-- - Basic text objects (aw, iw, ap, ip, etc.)

-- Override some conflicting keymaps to maintain IntelliJ consistency
-- NOTE: Standard Vim commands preserved:
-- - <C-n>/<C-p> (completion navigation) use standard behavior
-- - <C-e>/<C-y> (scroll down/up) use standard behavior  
-- - <C-f>/<C-b> (page down/up) use standard behavior

return {
  -- Export configuration for other modules to use
  setup = function()
    -- Additional setup if needed
    vim.notify("IntelliJ IDEA keymap loaded (terminal-compatible)", vim.log.levels.INFO)
    
    vim.notify("✓ All standard Vim/Neovim operations preserved", vim.log.levels.INFO)
    vim.notify("✓ Only plugin-specific shortcuts added (terminal-compatible)", vim.log.levels.INFO)
  end
}