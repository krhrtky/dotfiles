# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Neovim configuration using lazy.nvim as the plugin manager. The configuration is organized in a modular structure with separate files for different plugin categories and language-specific configurations.

## Architecture

### Core Structure
- `init.lua` - Entry point that loads config modules
- `lua/config/` - Core configuration files
  - `lazy.lua` - Lazy.nvim bootstrap and setup
  - `options.lua` - Vim options and settings
  - `keymap.lua` - Global keymaps
- `lua/plugins/` - Plugin configurations organized by category
  - `code.lua` - LSP, completion, diagnostics, and development tools
  - `ui.lua` - UI enhancements (neo-tree, lualine, treesitter, etc.)
  - `git.lua` - Git integration plugins
  - `colorscheme.lua` - Color scheme configuration
  - `kotlin.lua` - Kotlin language support
  - `rust.lua` - Rust language support
  - `spec1.lua` - Additional plugins and utilities

### Plugin Management
- Uses lazy.nvim for plugin management
- Plugins are auto-imported from the `plugins/` directory
- Plugin lock file: `lazy-lock.json`
- Lazy.nvim configuration includes auto-update checking

### Key Configuration Details

#### LSP Setup
- Uses lsp-zero.nvim v3.x as LSP configuration foundation
- Mason.nvim for LSP server management
- Language servers configured via mason-lspconfig.nvim
- Completion provided by nvim-cmp with LuaSnip

#### Language Support
- **Kotlin**: Full setup with kotlin_lsp, ktlint formatting/linting, debugging with kotlin-debug-adapter
- **Rust**: rust-analyzer, rustfmt, clippy, debugging with lldb, plus rust-tools.nvim and crates.nvim
- **General**: Treesitter parsers for multiple languages including Lua, JavaScript, HTML, JSON, Markdown

#### UI Configuration
- Colorscheme: Solarized light theme
- Status line: Lualine with solarized_light theme and globalstatus
- File explorer: Neo-tree (toggle with Ctrl+n)
- Search highlighting: nvim-hlslens
- Diagnostics display: tiny-inline-diagnostic.nvim and trouble.nvim

#### Development Tools
- Telescope for fuzzy finding (Leader+ff for files)
- Treesj for smart join/split
- Dial.nvim for smart increment/decrement
- Which-key for keymap hints
- Autopairs for bracket completion

## Common Commands

### Plugin Management
```vim
:Lazy                 " Open lazy.nvim interface
:Lazy update          " Update all plugins
:Lazy sync            " Install missing and update plugins
```

### LSP Commands
```vim
:LspInfo              " Show LSP server status
:LspInstall <server>  " Install LSP server
:Mason                " Open Mason interface for tool management
```

### File Navigation
- `<C-n>` - Toggle Neo-tree file explorer
- `<Leader>ff` - Telescope find files
- `<Leader>fp` - Find plugin files

### Diagnostics
- `<Leader>xx` - Toggle Trouble diagnostics
- `<Leader>xX` - Toggle buffer diagnostics

### Development Environment Setup

The configuration expects:
- Neovim 0.8+
- Git for plugin management
- Node.js and npm for some LSP servers
- Language-specific tools installed via Mason or system package manager

### Customization Notes

- Leader key is set to Space
- Local leader is backslash
- 2-space indentation is default
- Line numbers enabled
- System clipboard integration enabled
- Light background theme preference