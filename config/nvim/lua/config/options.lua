local opt = vim.opt
opt.number = true
opt.clipboard:append{"unnamedplus"}
opt.encoding = "utf-8"
-- opt.fileencoding = "utf-8"
opt.background = "light"
opt.wildmenu = true
opt.wildmode = "full"
opt.syntax = "on"
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true
opt.shiftwidth = 2
opt.cursorline = true
opt.directory = "/tmp"
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true
opt.completeopt = "menuone"
opt.backspace = "indent" , "eol", "start"
opt.laststatus = 3

local wo = vim.wo
wo.list = true
wo.listchars = 'tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%'
