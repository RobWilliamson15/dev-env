local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
	 "git",
	 "clone",
	 "--filter=blob:none",
	 "https://github.com/folke/lazy.nvim.git",
	 "--branch=stable",
	 lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Snacks
  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
   },
  },
    {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },

  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        -- add any options here
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d fewer lines' },
                { find = '%d more lines' },
              },
            },
            opts = { skip = true },
          }
        },
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  
  
    

  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- mocha, macchiato, frappe, latte
        transparent_background = false,
        term_colors = true,
        integrations = {
          telescope = true,
          harpoon = true,
          mason = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- nvim-wev-devicons
  { "nvim-tree/nvim-web-devicons", opts = {} },

  -- mini 
  { 'echasnovski/mini.nvim', version = false },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
    end,
  },

  -- Harpoon (file navigation)
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup({})
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "rust", "dockerfile", "go", "lua", "vim" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP (Language Server Protocol)
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup({}) -- Python
      lspconfig.rust_analyzer.setup({}) -- Rust
      lspconfig.gopls.setup({}) -- Go
      lspconfig.dockerls.setup({}) -- Docker
    end,
  },

  -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
})

-- Keybindings
vim.g.mapleader = " " -- Set leader key to space

-- Telescope keybindings
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })

-- Harpoon keybindings
vim.keymap.set("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = "Harpoon next" })
vim.keymap.set("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = "Harpoon previous" })

-- LSP keybindings
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Go to references" })
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code actions" })
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })


-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

-- Disable mouse mode
vim.o.mouse = ''

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.opt.spell = true
vim.opt.encoding = "utf-8" -- set encoding
vim.opt.nu = true -- enable line numbers
vim.opt.relativenumber = true -- relative line numbers

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- convert tabs to spaces
-- vim.wo.wrap = false -- do not wrap lines
vim.opt.autoindent = true -- auto indentation
vim.opt.list = true -- show tab characters and trailing whitespace
vim.opt.formatoptions:remove("t") -- no auto-intent of line breaks, keep line wrap enabled
vim.opt.listchars = "tab:»\\ ,extends:›,precedes:‹,nbsp:·,trail:·" -- show tab characters and trailing whitespace
