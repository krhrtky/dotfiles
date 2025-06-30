return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        formatting = lsp_zero.cmp_format({details = true}),
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      -- if you want to know more about mason.nvim
      -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,

          -- this is the "custom handler" for `lua_ls`
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-project.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    keys = {
      -- File operations
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find All Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
      { "<leader>fB", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File Browser (current dir)" },
      
      -- Search operations  
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sG", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep with Args" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Search Word under Cursor" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "Select Telescope" },
      
      -- Buffer operations
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      { "<leader>;", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      
      -- Git operations
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      
      -- LSP operations
      { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
      { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP Definitions" },
      { "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
      { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      
      -- Project management
      { "<leader>pp", "<cmd>Telescope projects<cr>", desc = "Switch Project" },
      
      -- Plugin files
      { "<leader>fp", function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end, desc = "Find Plugin File" },
      
      -- Resume last search
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          file_ignore_patterns = { 
            "%.git/", "node_modules/", "%.npm/", "%.cache/",
            "build/", "dist/", "target/", "%.o", "%.a", "%.out", "%.class",
            "%.pdf", "%.mkv", "%.mp4", "%.zip", "%.rar", "%.7z"
          },
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              -- ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key,
              ["<C-w>"] = { "<c-s-w>", type = "command" },
              ["<C-r><C-w>"] = function()
                local word = vim.fn.expand("<cword>")
                require('telescope.actions').insert_original_cword(vim.api.nvim_get_current_buf())
              end,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            layout_config = {
              height = 0.70,
            },
          },
          live_grep = {
            additional_args = function(opts)
              return {"--hidden"}
            end,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          git_files = {
            show_untracked = true,
          },
          oldfiles = {
            only_cwd = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                ["<A-c>"] = telescope.extensions.file_browser.actions.create,
                ["<S-CR>"] = telescope.extensions.file_browser.actions.create_from_prompt,
                ["<A-r>"] = telescope.extensions.file_browser.actions.rename,
                ["<A-m>"] = telescope.extensions.file_browser.actions.move,
                ["<A-y>"] = telescope.extensions.file_browser.actions.copy,
                ["<A-d>"] = telescope.extensions.file_browser.actions.remove,
                ["<C-o>"] = telescope.extensions.file_browser.actions.open,
                ["<C-g>"] = telescope.extensions.file_browser.actions.goto_parent_dir,
                ["<C-e>"] = telescope.extensions.file_browser.actions.goto_home_dir,
                ["<C-w>"] = telescope.extensions.file_browser.actions.goto_cwd,
                ["<C-t>"] = telescope.extensions.file_browser.actions.change_cwd,
                ["<C-f>"] = telescope.extensions.file_browser.actions.toggle_browser,
                ["<C-h>"] = telescope.extensions.file_browser.actions.toggle_hidden,
                ["<C-s>"] = telescope.extensions.file_browser.actions.toggle_all,
              },
              ["n"] = {
                ["c"] = telescope.extensions.file_browser.actions.create,
                ["r"] = telescope.extensions.file_browser.actions.rename,
                ["m"] = telescope.extensions.file_browser.actions.move,
                ["y"] = telescope.extensions.file_browser.actions.copy,
                ["d"] = telescope.extensions.file_browser.actions.remove,
                ["o"] = telescope.extensions.file_browser.actions.open,
                ["g"] = telescope.extensions.file_browser.actions.goto_parent_dir,
                ["e"] = telescope.extensions.file_browser.actions.goto_home_dir,
                ["w"] = telescope.extensions.file_browser.actions.goto_cwd,
                ["t"] = telescope.extensions.file_browser.actions.change_cwd,
                ["f"] = telescope.extensions.file_browser.actions.toggle_browser,
                ["h"] = telescope.extensions.file_browser.actions.toggle_hidden,
                ["s"] = telescope.extensions.file_browser.actions.toggle_all,
              },
            },
          },
          project = {
            base_dirs = {
              '~/projects',
              '~/work',
              '~/dotfiles',
            },
            hidden_files = true,
            theme = "dropdown",
            order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = true,
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      })
      
      -- Load extensions
      telescope.load_extension('fzf')
      telescope.load_extension('projects')
      telescope.load_extension('file_browser')
      telescope.load_extension('live_grep_args')
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config({ virtual_text = true }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        -- your trouble.nvim options here
      })

    end,

    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    'Wansmer/treesj',
    keys = { 
      { '<leader>tj', function() require('treesj').toggle() end, desc = 'Toggle TreeSJ' },
      { '<leader>ts', function() require('treesj').split() end, desc = 'TreeSJ Split' },
      { '<leader>tm', function() require('treesj').join() end, desc = 'TreeSJ Join' },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 120,
        cursor_behavior = 'hold',
        notify = true,
        langs = {},
        dot_repeat = true,
      })
    end,
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", mode = { "n", "v" } },
      { "<C-x>", mode = { "n", "v" } },
      { "g<C-a>", mode = { "v" } },
      { "g<C-x>", mode = { "v" } },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group{
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  
  -- Debug Adapter Protocol (DAP)
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
    },
    keys = {
      { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
      { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
      { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
      { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Debug: Set Conditional Breakpoint' },
      { '<leader>dr', function() require('dap').repl.open() end, desc = 'Debug: Open REPL' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run Last' },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      
      -- Setup dap-ui
      dapui.setup()
      
      -- Setup virtual text
      require('nvim-dap-virtual-text').setup()
      
      -- Auto-open/close dapui
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      
      -- Language-specific debug configurations will be handled in language files
    end,
  },
  
  -- Project Management
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        detection_methods = { 'lsp', 'pattern' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'Cargo.toml' },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath('data'),
      })
    end,
  },
  
  -- Terminal Integration
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-\\>', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
      { '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Toggle Horizontal Terminal' },
      { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle Vertical Terminal' },
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle Floating Terminal' },
    },
    config = function()
      require('toggleterm').setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      })
    end,
  },
  
  -- Test Framework
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rouge8/neotest-rust',
    },
    keys = {
      { '<leader>tt', function() require('neotest').run.run() end, desc = 'Test: Run Nearest' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Test: Run File' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Test: Toggle Summary' },
      { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Test: Show Output' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Test: Toggle Output Panel' },
      { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Test: Stop' },
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-rust') {
            args = { '--no-capture' },
            dap_adapter = 'lldb',
          },
        },
        status = {
          virtual_text = true,
        },
        output = {
          open_on_run = true,
        },
        quickfix = {
          open = function()
            if require('trouble').is_open() then
              vim.cmd('Trouble qflist')
            else
              vim.cmd('copen')
            end
          end,
        },
      })
    end,
  },
}
