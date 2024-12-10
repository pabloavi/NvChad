---@type NvPluginSpec[]
-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
local nvchad_plugins = vim.fn.stdpath "config" .. "/lua/plugins/nvchad"
local plugins = {

  "nvim-lua/plenary.nvim",

  {
    "stevearc/dressing.nvim",
    init = function()
      vim.defer_fn(function()
        require "dressing"
      end, 5000)
    end,
  },

  {
    dir = nvchad_plugins .. "/extensions",
    cmd = "AutosaveToggle",
    config = function()
      require("nvchad.autosave").setup()
    end,
  },

  {
    dir = nvchad_plugins .. "/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    dir = nvchad_plugins .. "/ui",
    lazy = false,
    config = function()
      require "nvchad_ui"
    end,
  },

  { -- wpm count to statusline
    "jcdickinson/wpm.nvim",
    config = function()
      require("wpm").setup()
    end,
  },

  {
    dir = nvchad_plugins .. "/nvterm",
    lazy = false,
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  { -- adds color to Blue or #0000FF
    dir = nvchad_plugins .. "/nvim-colorizer.lua",
    opts = function()
      return require("plugins.configs.others").colorizer
    end,
    init = function()
      require("core.utils").lazy_load "nvim-colorizer.lua"
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require("nvchad_ui.icons").devicons }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    -- commit = "9637670", -- TODO: update to v3
    version = "2.20.7",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("indent_blankline").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
      require("core.utils").load_mappings "treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      { "chrisgrieser/nvim-various-textobjs" },
      "David-Kunz/treesitter-unit",
    },
  },

  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    enabled = false,
    init = function()
      require("core.utils").lazy_load "rainbow-delimiters.nvim"
    end,
    config = function()
      require("rainbow-delimiters.setup").setup {
        query = { [""] = "rainbow-delimiters", latex = "rainbow-blocks" },
      }
    end,
  },

  -- get highlight group under cursor
  {
    "nvim-treesitter/playground",
    cmd = { "TSCaptureUnderCursor", "TSNodeUnderCursor", "TSPlaygroundToggle" },
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- ["nvim-treesitter/nvim-treesitter-context"] = {
  --   enabled = false,
  --   config = function(_, opts)
  --     require("treesitter-context").setup(opts)
  --   end,
  -- },

  {
    "RRethy/nvim-treesitter-textsubjects",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter-textsubjects"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter-textobjects"
    end,
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    opts = {
      useDefaultKeymaps = false,
    },
    init = function()
      require("core.utils").load_mappings "various_textobjs"
    end,
    config = function(_, opts)
      require("various-textobjs").setup(opts)
    end,
  },

  {
    "ckolkey/ts-node-action",
    config = function()
      require("ts-node-action").setup()
    end,
  },

  { "David-Kunz/treesitter-unit" },

  {
    "hiphish/nvim-ts-rainbow2",
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    ft = "gitcommit",
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitConfig", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        -- all elements of table opts.ensure_installed are installed
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      require("core.utils").lazy_load "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    init = function()
      require("core.utils").lazy_load "none-ls.nvim"
    end,
    config = function()
      require "plugins.configs.null-ls"
    end,
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
  },

  { "simrat39/inlay-hints.nvim", enabled = false },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = { "nvim-lspconfig", "dressing.nvim" },
    opts = function()
      return require "plugins.configs.rust_tools"
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },

  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        init = function()
          require("core.utils").load_mappings "luasnip"
        end,
        config = function()
          require "plugins.configs.luasnip"
        end,
        build = "make install_jsregexp",
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          require "plugins.configs.autopairs"

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        { "hrsh7th/cmp-omni", commit = "cec8d46" },
      },
    },

    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      require("core.utils").load_mappings "copilot"
    end,
    config = function()
      require("plugins.configs.others").copilot()
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  {
    "robitx/gp.nvim",
    lazy = false,
    config = function()
      require("plugins.configs.others").gp()
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    config = function()
      require("plugins.configs.others").copilotChat()
    end,
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    init = function()
      require("core.utils").lazy_load "lsp_lines.nvim"
    end,
    config = function()
      require("plugins.configs.others").lsp_lines()
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb" },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function()
      require("Comment").setup()
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
    end,
  },

  {
    "prichrd/netrw.nvim",
    enabled = false, -- make it false when not using oil.nvim
    lazy = false,
    opts = function()
      return require("plugins.configs.others").netrw
    end,
    config = function(_, opts)
      require("netrw").setup(opts)
    end,
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = function()
      return { keymaps = { ["q"] = "actions.close" } }
    end,
    config = function(_, opts)
      require("oil").setup(opts)
    end,
  },

  {
    "kevinhwang91/rnvimr",
    enabled = false,
    cmd = "RnvimrToggle",
    init = function()
      require("core.utils").load_mappings "rnvimr"
    end,
    config = function()
      require("plugins.configs.others").rnvimr()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,

    opts = function()
      return require "plugins.configs.telescope"
    end,

    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  { "benfowler/telescope-luasnip.nvim", cmd = "Telescope luasnip" },
  { "debugloop/telescope-undo.nvim", cmd = "Telescope undo" },
  { "wintermute-cell/gitignore.nvim", cmd = "Gitignore" },
  { "nvim-telescope/telescope-bibtex.nvim", cmd = "Telescope bibtex" },

  -- { "nvim-telescope/telescope-dap.nvim", cmd = "Telescope dap" },

  { "ThePrimeagen/harpoon" },

  {
    "potamides/pantran.nvim",
    enabled = false,
    cmd = "Pantran",
    config = function()
      require("plugins.configs.others").pantran()
    end,
  },

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`" },
    init = function()
      require("core.utils").load_mappings "whichkey"
    end,
    opts = function()
      return require "plugins.configs.whichkey"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  {
    "folke/todo-comments.nvim",
    init = function()
      require("core.utils").lazy_load "todo-comments.nvim"
    end,
    config = function()
      require("todo-comments").setup { highlight = { comments_only = false } } -- TODO: wait for typst treesitter support and remove this option
    end,
  },

  {
    "RRethy/vim-illuminate",
    init = function()
      require("core.utils").lazy_load "vim-illuminate"
    end,
    config = function()
      require("plugins.configs.others").illuminate()
    end,
  },

  -- motion
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- fast moving (like vimium)
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- misc
  -- {
  --   "Pocco81/TrueZen.nvim",
  --   cmd = {
  --     "TZAtaraxis",
  --     "TZMinimalist",
  --     "TZFocus",
  --   },
  --   init = function()
  --     require("core.utils").load_mappings "truezen"
  --   end,
  --   config = function()
  --     require("plugins.configs.others").truezen()
  --   end,
  -- },

  {
    "Pocco81/auto-save.nvim",
    enabled = false,
    config = function()
      require("plugins.configs.others").autosave()
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    init = function()
      require("core.utils").load_mappings "zenmode"
    end,
  },

  { "folke/twilight.nvim" },

  {
    "folke/noice.nvim",
    enabled = false,
    config = function()
      require "plugins.configs.noice"
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- ft plugins
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",
    -- build = ":Neorg sync-parsers",
    dependencies = { "luarocks.nvim" },
    init = function()
      require("plugins.configs.neorg").autocmd()
      require("core.utils").load_mappings "neorg"
    end,
    config = function()
      require("plugins.configs.neorg").setup()
    end,
  },

  { "elkowar/yuck.vim", ft = "yuck", enabled = false },

  { "theRealCarneiro/hyprland-vim-syntax", ft = "hypr", enabled = true },

  { "lervag/vimtex", ft = "tex", lazy = false, enabled = true },

  {
    "f3fora/nvim-texlabconfig",
    enabled = false,
    config = function()
      require("texlabconfig").setup()
    end,
    ft = { "tex", "bib" }, -- Lazy-load on filetype
    build = "go build -o ~/.local/bin/",
  },

  {
    "barreiroleo/ltex-extra.nvim",
    enabled = false,
    ft = "tex",
    opts = function()
      return require("plugins.configs.others").ltex_extra
    end,
    config = function(_, opts)
      require("ltex_extra").setup(opts)
    end,
  },

  -- airlatex
  -- {
  --   "pabloavi/AirLatex.vim",
  --   lazy = false,
  -- },
  {
    "dmadisetti/AirLatex.vim",
    lazy = false,
  },

  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = "MarkdownPreviewToggle",
  --   ft = "markdown",
  --   build = "cd app && npm install",
  --   init = function()
  --     vim.g.mkdp_filetypes = { "markdown" }
  --     require("core.utils").load_mappings "markdownpreview"
  --   end,
  -- },

  -- Preview websites
  {
    "ray-x/web-tools.nvim",
    ft = { "html", "css", "js" },
    config = function()
      require("web-tools").setup()
    end,
  },

  -- TODO: improve dap config and usage
  {
    "mfussenegger/nvim-dap",
    enabled = true,
    init = function()
      require("core.utils").load_mappings "dap"
    end,
    config = function()
      require "dressing"
      require "plugins.configs.dap"
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "python" },
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("plugins.configs.others").dapui()
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("plugins.configs.others").dap_virtual_text()
    end,
  },

  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
    dependencies = "nvim-lua/plenary.nvim",
    init = function()
      require("core.utils").load_mappings "code_runner"
    end,
    config = function()
      require("plugins.configs.others").code_runner()
    end,
  },

  {
    "michaelb/sniprun",
    cmd = "SnipRun",
    build = "sh ./install.sh",
    opts = function()
      return require("plugins.configs.others").sniprun
    end,
    config = function(_, opts)
      require("sniprun").setup(opts)
    end,
  },

  {
    "ziontee113/icon-picker.nvim",
    cmd = { "IconPickerInsert", "IconPickerNormal", "IconPickerYank" },
    init = function()
      require("core.utils").load_mappings "icon_picker"
    end,
    config = function()
      require "dressing"
      require("icon-picker").setup {}
    end,
  },

  {
    "ziontee113/color-picker.nvim",
    cmd = { "PickColor", "PickColorInsert" },
    init = function()
      require("core.utils").load_mappings "color_picker"
    end,
    config = function()
      require "color-picker"
    end,
  },

  { "dstein64/vim-startuptime", cmd = "StartupTime" },

  {
    "smjonas/snippet-converter.nvim",
    enabled = false,
    config = function()
      require("plugins.configs.others").snippet_converter()
    end,
  },

  { -- show marks (a,b...) in statuscolumn
    "chentoast/marks.nvim",
    init = function()
      require("core.utils").lazy_load "marks.nvim"
    end,
    config = function()
      require("marks").setup()
    end,
  },

  {
    "AckslD/muren.nvim",
    cmd = { "MurenToggle", "MurenOpen", "MurenClose", "MurenFresh", "MurenUnique" },
    config = true,
  },

  -- fix nested neovims
  -- TODO: lazy lua
  { "samjwill/nvim-unception", enabled = false, event = "VeryLazy" },

  { "eandrju/cellular-automaton.nvim", cmd = "CellularAutomaton" },

  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },

  -- folds
  -- TODO: lazy load
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    dependencies = "kevinhwang91/promise-async",
    opts = function()
      return require("plugins.configs.others").ufo.options()
    end,
    init = function()
      require("core.utils").lazy_load "nvim-ufo"
      require("core.utils").load_mappings "ufo"
      require("plugins.configs.others").ufo.init()
    end,
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
  },

  {
    "glepnir/template.nvim",
    lazy = false,
    cmd = { "Template", "TemProject" },
    opts = function()
      return require("plugins.configs.others").template
    end,
    config = function(_, opts)
      require("template").setup(opts)
    end,
  },

  {
    "glacambre/firenvim",
    lazy = false,
    config = function()
      require("plugins.configs.others").firenvim()
    end,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },

  { "AndrewRadev/bufferize.vim", enabled = false },

  { "waycrate/swhkd-vim", lazy = false },

  { "luckasRanarison/tree-sitter-hypr", lazy = false },

  {
    "kaarmu/typst.vim",
    ft = "typst",
    lazy = false,
  },

  {
    "chomosuke/typst-preview.nvim",
    -- lazy = false,
    ft = "typst",
    version = "0.1.*",
    build = function()
      require("typst-preview").update()
    end,
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
  },

  {
    "karb94/neoscroll.nvim",
    enabled = false,
    lazy = false,
    config = function()
      if vim.g.neovide then
        require("neoscroll").setup {}
      end
    end,
  },
  {
    "antoinemadec/openrgb.nvim",
    enabled = false,
    build = "UpdateRemotePlugins",
    lazy = false,
    config = function()
      require("plugins.configs.others").openrgb()
    end,
  },

  {
    "petRUShka/vim-sage",
    ft = "sage.python",
  },

  {
    "nosduco/remote-sshfs.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = function()
      return require("plugins.configs.others").remote_sshfs
    end,
    init = function(opts, _)
      require("remote-sshfs").setup(opts)
    end,
  },
}

local config = require("core.utils").load_config()

require("lazy").setup(plugins, config.lazy_nvim)
