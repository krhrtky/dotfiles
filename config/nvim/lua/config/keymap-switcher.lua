-- Keymap Switcher: Toggle between default and IntelliJ IDEA keymaps
-- Usage: 
--   :lua require('config.keymap-switcher').use_intellij()
--   :lua require('config.keymap-switcher').use_default()
--   :lua require('config.keymap-switcher').toggle()

local M = {}

-- Current keymap state
M.current_keymap = "default"
M.intellij_loaded = false

-- Store original keymaps to restore later
M.original_keymaps = {}

-- Function to backup current keymaps
local function backup_keymaps()
  if vim.tbl_isempty(M.original_keymaps) then
    -- Key keymaps to backup before switching
    local keys_to_backup = {
      { "n", "<C-n>" },
      { "n", "<leader>ff" },
      { "n", "<leader>sg" },
      { "n", "<leader>bd" },
      { "n", "<C-s>" },
      { "n", "gcc" },
      { "v", "gc" },
    }
    
    for _, key_info in ipairs(keys_to_backup) do
      local mode, key = key_info[1], key_info[2]
      local existing = vim.fn.maparg(key, mode, false, true)
      if existing and existing.buffer == 0 then -- global mapping
        M.original_keymaps[mode .. key] = existing
      end
    end
  end
end

-- Function to restore original keymaps
local function restore_keymaps()
  for key_id, mapping in pairs(M.original_keymaps) do
    if mapping.rhs then
      vim.keymap.set(mapping.mode, mapping.lhs, mapping.rhs, {
        noremap = mapping.noremap == 1,
        silent = mapping.silent == 1,
        expr = mapping.expr == 1,
        desc = mapping.desc,
      })
    end
  end
end

-- Load IntelliJ IDEA keymaps
function M.use_intellij()
  if M.current_keymap == "intellij" then
    vim.notify("IntelliJ keymap already active", vim.log.levels.INFO)
    return
  end
  
  -- Backup current keymaps first
  backup_keymaps()
  
  -- IntelliJ keymap is now terminal-compatible across all platforms
  vim.notify("Loading terminal-compatible IntelliJ keymap...", vim.log.levels.INFO)
  
  -- Load IntelliJ keymaps
  local success, intellij_keymaps = pcall(require, 'config.intellij-keymaps')
  if success then
    if intellij_keymaps.setup then
      intellij_keymaps.setup()
    end
    M.intellij_loaded = true
    M.current_keymap = "intellij"
    vim.notify("Switched to IntelliJ IDEA keymap", vim.log.levels.INFO)
    
    -- Create command for quick access
    vim.api.nvim_create_user_command('IntellijKeymap', function()
      M.use_intellij()
    end, { desc = 'Switch to IntelliJ IDEA keymap' })
    
    -- Show some key mappings for reference
    vim.notify("Key IntelliJ shortcuts (terminal-compatible):\n" ..
               "Ctrl+O: Go to File\n" ..
               "Ctrl+Shift+O: Find in Files\n" ..
               "Alt+1: Project Tree\n" ..
               "Ctrl+/: Comment Line\n" ..
               "<leader>ld: Duplicate Line\n" ..
               "F1: Quick Documentation\n" ..
               "F9: Build Project\n" ..
               "F12: Terminal", vim.log.levels.INFO)
  else
    vim.notify("Failed to load IntelliJ keymap: " .. tostring(intellij_keymaps), vim.log.levels.ERROR)
  end
end

-- Restore default keymaps
function M.use_default()
  if M.current_keymap == "default" then
    vim.notify("Default keymap already active", vim.log.levels.INFO)
    return
  end
  
  -- Clear IntelliJ keymaps by reloading default keymaps
  if M.intellij_loaded then
    -- We'll need to reload the default keymap files
    local success, _ = pcall(require, 'config.keymaps')
    if success then
      M.current_keymap = "default"
      M.intellij_loaded = false
      vim.notify("Switched to default Neovim keymap", vim.log.levels.INFO)
      
      -- Create command for quick access
      vim.api.nvim_create_user_command('DefaultKeymap', function()
        M.use_default()
      end, { desc = 'Switch to default Neovim keymap' })
    else
      vim.notify("Failed to reload default keymap", vim.log.levels.ERROR)
    end
  end
end

-- Toggle between keymaps
function M.toggle()
  if M.current_keymap == "default" then
    M.use_intellij()
  else
    M.use_default()
  end
end

-- Get current keymap status
function M.status()
  local status = {
    current = M.current_keymap,
    intellij_loaded = M.intellij_loaded,
    terminal_compatible = true,
  }
  
  vim.notify("Current keymap: " .. M.current_keymap, vim.log.levels.INFO)
  return status
end

-- Setup function to initialize commands
function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command('KeymapStatus', function()
    M.status()
  end, { desc = 'Show current keymap status' })
  
  vim.api.nvim_create_user_command('KeymapToggle', function()
    M.toggle()
  end, { desc = 'Toggle between default and IntelliJ keymaps' })
  
  vim.api.nvim_create_user_command('IntellijKeymap', function()
    M.use_intellij()
  end, { desc = 'Switch to IntelliJ IDEA keymap' })
  
  vim.api.nvim_create_user_command('DefaultKeymap', function()
    M.use_default()
  end, { desc = 'Switch to default Neovim keymap' })
  
  -- Add to leader help if which-key is available
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.register({
      ["<leader>km"] = {
        name = "Keymap Switcher",
        s = { "<cmd>KeymapStatus<cr>", "Show Status" },
        t = { "<cmd>KeymapToggle<cr>", "Toggle Keymap" },
        i = { "<cmd>IntellijKeymap<cr>", "IntelliJ Keymap" },
        d = { "<cmd>DefaultKeymap<cr>", "Default Keymap" },
      }
    })
  end
  
  -- Set up keymap for quick toggling
  vim.keymap.set("n", "<leader>kt", M.toggle, { desc = "Toggle Keymap (Default/IntelliJ)" })
end

return M