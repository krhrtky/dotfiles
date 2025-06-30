-- IntelliJ IDEA-style Keymaps for Neovim
-- Based on IntelliJ IDEA default keymap for macOS
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ============================================================================
-- NAVIGATION
-- ============================================================================

-- Quick Navigation
keymap.set("n", "<D-o>", "<cmd>Telescope find_files<cr>", { desc = "Go to File" })
keymap.set("n", "<D-S-o>", "<cmd>Telescope live_grep<cr>", { desc = "Find in Files" })
keymap.set("n", "<D-e>", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
keymap.set("n", "<D-S-a>", "<cmd>Telescope builtin<cr>", { desc = "Find Action" })

-- Class/Symbol Navigation  
keymap.set("n", "<D-f12>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "File Structure" })
keymap.set("n", "<D-S-f12>", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Navigate to Symbol" })
keymap.set("n", "<D-b>", function() require('telescope.builtin').lsp_definitions() end, { desc = "Go to Declaration" })
keymap.set("n", "<D-S-b>", function() require('telescope.builtin').lsp_type_definitions() end, { desc = "Go to Type Declaration" })
keymap.set("n", "<D-u>", function() require('telescope.builtin').lsp_implementations() end, { desc = "Go to Implementation" })

-- Code Navigation
keymap.set("n", "<C-[>", "<C-o>", { desc = "Navigate Back" })
keymap.set("n", "<C-]>", "<C-i>", { desc = "Navigate Forward" })
keymap.set("n", "<D-g>", function() vim.ui.input({ prompt = "Go to line: " }, function(input) if input then vim.cmd(input) end end) end, { desc = "Go to Line" })

-- Search/Replace
keymap.set("n", "<D-f>", "/", { desc = "Find" })
keymap.set("n", "<D-r>", ":%s/", { desc = "Replace" })
keymap.set("n", "<D-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Find in Path" })
keymap.set("n", "<D-S-r>", "<cmd>Telescope live_grep_args<cr>", { desc = "Replace in Path" })

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================

-- File Management
keymap.set("n", "<D-n>", "<cmd>enew<cr>", { desc = "New File" })
keymap.set("n", "<D-s>", "<cmd>w<cr>", { desc = "Save" })
keymap.set("n", "<D-S-s>", "<cmd>wa<cr>", { desc = "Save All" })
keymap.set("n", "<D-w>", function()
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
keymap.set("n", "<D-1>", "<cmd>Neotree toggle<cr>", { desc = "Project Tree" })

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
keymap.set("n", "<D-CR>", vim.lsp.buf.code_action, { desc = "Show Context Actions" })
keymap.set("n", "<D-S-CR>", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.kind and string.match(action.kind, "quickfix")
    end,
    apply = true,
  })
end, { desc = "Quick Fix" })

-- Code Generation
keymap.set("n", "<D-S-g>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Parameter Info" })
keymap.set("i", "<D-S-g>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Parameter Info" })

-- Refactoring
keymap.set("n", "<S-F6>", vim.lsp.buf.rename, { desc = "Rename" })
keymap.set("n", "<D-S-F6>", "<cmd>Telescope lsp_references<cr>", { desc = "Find Usages" })

-- Code Formatting
keymap.set("n", "<D-S-l>", function() vim.lsp.buf.format({ async = true }) end, { desc = "Reformat Code" })
keymap.set("v", "<D-S-l>", function() vim.lsp.buf.format({ async = true }) end, { desc = "Reformat Code" })

-- Comments
keymap.set("n", "<D-/>", "gcc", { desc = "Comment Line", remap = true })
keymap.set("v", "<D-/>", "gc", { desc = "Comment Selection", remap = true })
keymap.set("n", "<D-S-/>", "gbc", { desc = "Block Comment", remap = true })

-- Code Folding
keymap.set("n", "<D-=>", "zo", { desc = "Expand" })
keymap.set("n", "<D-->", "zc", { desc = "Collapse" })
keymap.set("n", "<D-S-=>", "zR", { desc = "Expand All" })
keymap.set("n", "<D-S-->", "zM", { desc = "Collapse All" })

-- ============================================================================
-- SELECTION & EDITING
-- ============================================================================

-- Text Selection
keymap.set("n", "<D-a>", "ggVG", { desc = "Select All" })
keymap.set("n", "<D-S-w>", "viw", { desc = "Extend Selection to Word" })
keymap.set("n", "<D-S-[>", "V{", { desc = "Extend Selection to Paragraph" })
keymap.set("n", "<D-S-]>", "V}", { desc = "Extend Selection to Paragraph" })

-- Multiple Cursors (IntelliJ-style)
keymap.set("n", "<D-d>", "<C-m>", { desc = "Add Selection for Next Occurrence", remap = true })
keymap.set("v", "<D-d>", "<C-m>", { desc = "Add Selection for Next Occurrence", remap = true })
keymap.set("n", "<D-S-d>", "<C-S-m>", { desc = "Select All Occurrences", remap = true })

-- Line Operations
keymap.set("n", "<D-S-Up>", ":move .-2<CR>==", { desc = "Move Line Up" })
keymap.set("n", "<D-S-Down>", ":move .+1<CR>==", { desc = "Move Line Down" })
keymap.set("v", "<D-S-Up>", ":move '<-2<CR>gv=gv", { desc = "Move Lines Up" })
keymap.set("v", "<D-S-Down>", ":move '>+1<CR>gv=gv", { desc = "Move Lines Down" })

keymap.set("n", "<D-l>", ":copy .<CR>", { desc = "Duplicate Line" })
keymap.set("v", "<D-l>", ":copy '><CR>gv", { desc = "Duplicate Selection" })

-- Clipboard Operations
keymap.set("n", "<D-c>", '"+y', { desc = "Copy" })
keymap.set("v", "<D-c>", '"+y', { desc = "Copy" })
keymap.set("n", "<D-x>", '"+x', { desc = "Cut" })
keymap.set("v", "<D-x>", '"+x', { desc = "Cut" })
keymap.set("n", "<D-v>", '"+p', { desc = "Paste" })
keymap.set("i", "<D-v>", '<C-r>+', { desc = "Paste" })

-- Undo/Redo
keymap.set("n", "<D-z>", "u", { desc = "Undo" })
keymap.set("n", "<D-S-z>", "<C-r>", { desc = "Redo" })

-- ============================================================================
-- VIEW & WINDOWS
-- ============================================================================

-- Tool Windows
keymap.set("n", "<D-S-1>", "<cmd>Neotree reveal<cr>", { desc = "Select in Project Tree" })
keymap.set("n", "<D-6>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems Tool Window" })
keymap.set("n", "<D-9>", "<cmd>Telescope git_status<cr>", { desc = "Version Control" })

-- Editor Tabs
keymap.set("n", "<D-S-[>", "<cmd>bprevious<cr>", { desc = "Previous Tab" })
keymap.set("n", "<D-S-]>", "<cmd>bnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<D-S-w>", "<cmd>bdelete<cr>", { desc = "Close Tab" })

-- Split Windows
keymap.set("n", "<D-S-v>", "<cmd>vsplit<cr>", { desc = "Split Vertically" })
keymap.set("n", "<D-S-h>", "<cmd>split<cr>", { desc = "Split Horizontally" })

-- Focus
keymap.set("n", "<D-S-F12>", function()
  vim.cmd("only")
  vim.cmd("Neotree close")
end, { desc = "Hide All Tool Windows" })

-- ============================================================================
-- BUILD & RUN
-- ============================================================================

-- Build
keymap.set("n", "<D-F9>", function()
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
keymap.set("n", "<D-S-F9>", function() require('dap').toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
keymap.set("n", "<D-S-F8>", function() require('dap').continue() end, { desc = "Resume Program" })
keymap.set("n", "<F8>", function() require('dap').step_over() end, { desc = "Step Over" })
keymap.set("n", "<F7>", function() require('dap').step_into() end, { desc = "Step Into" })
keymap.set("n", "<S-F8>", function() require('dap').step_out() end, { desc = "Step Out" })

-- Debug Windows
keymap.set("n", "<D-5>", function() require('dapui').toggle() end, { desc = "Debug Tool Window" })

-- ============================================================================
-- TESTING
-- ============================================================================

-- Test Execution
keymap.set("n", "<C-S-R>", function() require('neotest').run.run() end, { desc = "Run Test" })
keymap.set("n", "<D-S-F10>", function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = "Run Tests in File" })

-- ============================================================================
-- GIT/VCS
-- ============================================================================

-- Version Control
keymap.set("n", "<D-k>", "<cmd>Telescope git_commits<cr>", { desc = "VCS Operations Popup" })
keymap.set("n", "<D-S-k>", "<cmd>Telescope git_status<cr>", { desc = "Commit Changes" })

-- ============================================================================
-- TERMINAL
-- ============================================================================

-- Terminal
keymap.set("n", "<D-F12>", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })
keymap.set("t", "<D-F12>", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })

-- ============================================================================
-- HELP & INFORMATION
-- ============================================================================

-- Quick Documentation
keymap.set("n", "<F1>", function() vim.lsp.buf.hover() end, { desc = "Quick Documentation" })
keymap.set("n", "<D-j>", function() vim.lsp.buf.hover() end, { desc = "Quick Documentation" })

-- External Documentation
keymap.set("n", "<S-F1>", function()
  -- Try to open external documentation
  local word = vim.fn.expand("<cword>")
  vim.fn.system("open https://docs.rs/" .. word)
end, { desc = "External Documentation" })

-- Parameter Info
keymap.set("n", "<D-p>", function() vim.lsp.buf.signature_help() end, { desc = "Parameter Info" })
keymap.set("i", "<D-p>", function() vim.lsp.buf.signature_help() end, { desc = "Parameter Info" })

-- ============================================================================
-- MISCELLANEOUS
-- ============================================================================

-- IntelliJ-style Exit
keymap.set("n", "<D-q>", function()
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
keymap.set("n", "<D-,>", "<cmd>Lazy<cr>", { desc = "Preferences" })

-- Show usages
keymap.set("n", "<D-S-F7>", function() require('telescope.builtin').lsp_references() end, { desc = "Find Usages" })

-- IntelliJ-style recently changed files
keymap.set("n", "<D-S-e>", function()
  require('telescope.builtin').oldfiles({
    only_cwd = true,
    -- Show files changed in last session
  })
end, { desc = "Recently Changed Files" })

-- Bookmarks (using Harpoon)
keymap.set("n", "<F11>", function() require('harpoon'):list():append() end, { desc = "Toggle Bookmark" })
keymap.set("n", "<D-F11>", function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, { desc = "Show Bookmarks" })

-- Context Info
keymap.set("n", "<D-S-p>", function() 
  -- Show current context (file path, line number, etc.)
  local buf_name = vim.api.nvim_buf_get_name(0)
  local line_nr = vim.api.nvim_win_get_cursor(0)[1]
  local col_nr = vim.api.nvim_win_get_cursor(0)[2] + 1
  local rel_path = vim.fn.fnamemodify(buf_name, ":.")
  vim.notify(string.format("%s:%d:%d", rel_path, line_nr, col_nr), vim.log.levels.INFO)
end, { desc = "Context Info" })

-- Override some conflicting keymaps to maintain IntelliJ consistency
-- These will override the default keymaps in keymaps.lua when this module is loaded
keymap.set("n", "<C-n>", function()
  -- IntelliJ uses Ctrl+N for "Go to Class", we'll use Telescope symbols
  require('telescope.builtin').lsp_workspace_symbols()
end, { desc = "Go to Class" })

return {
  -- Export configuration for other modules to use
  setup = function()
    -- Additional setup if needed
    vim.notify("IntelliJ IDEA keymap loaded", vim.log.levels.INFO)
  end
}