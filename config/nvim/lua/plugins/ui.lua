return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    config = function()
      require('neo-tree').setup {
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        filesystem = {
          filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
          }
        },
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        theme = 'solarized_light',
        options = {
          globalstatus = true,
        }
      }
    end
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require('hlslens').setup()
    end
  },
  {
    'b0o/incline.nvim',
    config = function()
      require('incline').setup()
    end,
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- Add syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "json", "kotlin", "markdown" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  
  -- Buffer Management
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    event = "VeryLazy",
    config = function()
      require('barbar').setup({
        animation = true,
        auto_hide = false,
        tabpages = true,
        closable = true,
        clickable = true,
        focus_on_close = 'left',
        hide = {extensions = true, inactive = false},
        highlight_alternate = false,
        highlight_inactive_file_icons = false,
        highlight_visible = true,
        icons = {
          buffer_index = false,
          buffer_number = false,
          button = '',
          diagnostics = {
            [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
            [vim.diagnostic.severity.WARN] = {enabled = false},
            [vim.diagnostic.severity.INFO] = {enabled = false},
            [vim.diagnostic.severity.HINT] = {enabled = true},
          },
          gitsigns = {
            added = {enabled = true, icon = '+'},
            changed = {enabled = true, icon = '~'},
            deleted = {enabled = true, icon = '-'},
          },
          filetype = {
            custom_colors = false,
            enabled = true,
          },
          separator = {left = '▎', right = ''},
          separator_at_end = true,
          modified = {button = '●'},
          pinned = {button = '', filename = true},
          preset = 'default',
          alternate = {filetype = {enabled = false}},
          current = {buffer_index = true},
          inactive = {button = '×'},
          visible = {modified = {buffer_number = false}},
        },
        insert_at_end = true,
        insert_at_start = false,
        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        minimum_length = 0,
        semantic_letters = true,
        sidebar_filetypes = {
          NvimTree = true,
          ['neo-tree'] = {event = 'BufWipeout', text = 'File Explorer'},
        },
        sort = {
          enabled = true,
          ignore_case = true,
        },
      })
    end,
  },
  
  -- Enhanced Indent Visualization
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('ibl').setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          injected_languages = false,
          highlight = { "Function", "Label" },
          priority = 500,
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      })
    end,
  },
}
