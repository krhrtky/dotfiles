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
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick Buffer' },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick Close Buffer' },
      { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close Other Buffers' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = 'Close Buffers to Right' },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close Buffers to Left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Previous Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to Buffer 1' },
      { '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to Buffer 2' },
      { '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to Buffer 3' },
      { '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to Buffer 4' },
      { '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Go to Buffer 5' },
      { '<leader>6', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Go to Buffer 6' },
      { '<leader>7', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Go to Buffer 7' },
      { '<leader>8', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Go to Buffer 8' },
      { '<leader>9', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Go to Buffer 9' },
    },
    config = function()
      require('bufferline').setup({
        options = {
          mode = "buffers",
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = '▎',
            style = 'icon',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 30,
          max_prefix_length = 30,
          truncate_names = true,
          tab_size = 21,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,
          separator_style = "slant",
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          sort_by = 'insert_after_current',
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            }
          },
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
