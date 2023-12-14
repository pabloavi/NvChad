local M = {}
local utils = require "core.utils"

M.blankline = {
  indentLine_enabled = 1,
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "nvdash",
    "nvcheatsheet",
    "oil_preview",
    "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
}

M.gitsigns = {
  signs = {
    add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
    change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
    delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
    untracked = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
  },
  on_attach = function(bufnr)
    utils.load_mappings("gitsigns", { buffer = bufnr })
  end,
}

-- TODO: refactor from here to eof
M.colorizer = {
  filetypes = {
    "*",
  },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = false, -- "Name" codes like Blue
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    rgb_fn = false, -- CSS rgb() and rgba() functions
    hsl_fn = false, -- CSS hsl() and hsla() functions
    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    mode = "background", -- Set the display mode.
  },
}

M.netrw = {
  mappings = {
    -- ["<Tab>"] = function()
    --   require("nvchad_ui.tabufline").tabuflineNext()
    -- end,
    -- ["<S-Tab>"] = function()
    --   require("nvchad_ui.tabufline").tabuflinePrev()
    -- end,
  },
}

M.snippet_converter = function()
  local template = {
    sources = {
      ultisnips = { vim.fn.stdpath "config" .. "/converter/input/UltiSnips" },
      snipmate = { "vim-snippets/snippets" },
    },
    output = {
      snipmate_luasnip = { vim.fn.stdpath "config" .. "/converter/output/snipmate_luasnip" },
    },
  }
  require("snippet_converter").setup {
    templates = { template },
  }
end

M.illuminate = function()
  local present, illuminate = pcall(require, "illuminate")

  if not present then
    return
  end
  illuminate.configure {
    providers = { "lsp", "treesitter", "regex" },
    delay = 100,
    modes_denylist = { "i" },
    filetypes_denylist = {
      "latex",
      "tex",
      "plaintex",
      "oil",
      "oil-preview",
      "lazy",
    },
  }
end

M.truezen = function()
  local present, truzen = pcall(require, "true-zen")

  if not present then
    return
  end

  local options = {
    ui = {
      top = {
        showtabline = 0,
      },
      left = {
        number = false,
      },
    },
    modes = {
      ataraxis = {
        left_padding = 3,
        right_padding = 3,
        top_padding = 1,
        bottom_padding = 0,
        auto_padding = false,
      },
    },
  }

  truzen.setup(options)
end

M.copilot = function()
  local present, copilot = pcall(require, "copilot")

  if not present then
    return
  end

  local options = {
    panel = {
      auto_refresh = false,
      keymap = {
        accept = "<CR>",
        jump_prev = "[[",
        jump_next = "]]",
        refresh = "gr",
        open = "<M-CR>",
      },
      layout = {
        position = "right",
        ratio = 0.4,
      },
    },
    suggestion = {
      auto_trigger = true,
      keymap = {
        -- accept = "<Tab>",
        accept = false,
        prev = "<M-[>",
        next = "<M-]>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
  }

  -- local options = { -- with copilot-cmp
  --   suggestion = { enabled = false },
  --   panel = { enabled = false },
  -- }

  copilot.setup(options)
end

M.lsp_lines = function()
  local present, lsp_lines = pcall(require, "lsp_lines")

  if not present then
    return
  end

  local options = {
    hl = "LspDiagnosticsDefaultHint",
    prefix = "",
    icons_enabled = true,
  }

  lsp_lines.setup(options)

  if vim.g.lsp_lines_enabled then
    vim.diagnostic.config { virtual_lines = true, virtual_text = false }
  else
    vim.diagnostic.config { virtual_lines = false, virtual_text = true }
  end
end

M.autosave = function()
  local present, autosave = pcall(require, "auto-save")

  if present then
    autosave.setup()
  end
end

M.dap_virtual_text = function()
  local present, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")

  if present then
    dap_virtual_text.setup()
  end
end

M.code_runner = function()
  local present, code_runner = pcall(require, "code_runner")

  if not present then
    return
  end

  local file = vim.fn.expand "%:t"
  local file_no_ext = vim.fn.expand "%:r"

  local options = {
    filetype = {
      python = "cd '$dir' && python3 " .. file,
      lua = "cd '$dir' && lua " .. file,
      sh = "cd '$dir' && sh " .. file,
      c = "cd '$dir' && gcc " .. file .. " -o " .. file_no_ext .. " && " .. file_no_ext,
      fortran = "cd '$dir' && gfortran " .. file .. " -o " .. file_no_ext .. " && " .. file_no_ext,
      rust = "cd '$dir' && cargo run",
    },
    mode = "float",
    float = { -- Numbers 0 - 1 for measurements
      border = "single",
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,
    },
  }

  code_runner.setup(options)
end

M.dapui = function()
  local present, dapui = pcall(require, "dapui")

  if not present then
    return
  end

  dapui.setup()
end

M.sniprun = {
  borders = "single",
  display = {
    "TempFloatingWindow",
  },
}

M.delaytrain = function()
  local present, delaytrain = pcall(require, "delaytrain")

  if not present then
    return
  end

  local options = {
    delay_ms = 1000, -- How long repeated usage of a key should be prevented
    grace_period = 1, -- How many repeated keypresses are allowed
    keys = {
      ["nv"] = { "h", "j", "k", "l" },
      ["nvi"] = { "<Left>", "<Down>", "<Up>", "<Right>" },

      ["n"] = { "b", "w", "B", "W", "db", "dw", "dB", "dW", "x", "X" },
    },
    ignore_filetypes = {},
  }

  delaytrain.setup(options)
end

M.ufo = {
  init = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.statuscolumn = "%= %s%{%&number ?(v:relnum ?"
      .. 'printf("%"..len(line("$")).."s", v:relnum)'
      .. ":v:lnum):"
      .. '""'
      .. " %}%= %#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1)? (foldclosed(v:lnum) == -1"
      .. '? ""'
      .. ':  ""'
      .. ")"
      .. ': " "'
      .. "}%= "
    -- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    --   pattern = "*.tex",
    --   callback = function()
    --     vim.cmd [[normal! zM]]
    --   end,
    -- })
  end,

  options = function()
    return {
      open_fold_hl_timeout = 0,
    }
  end,
}

M.firenvim = function()
  local present, _ = pcall(require, "firenvim")

  if not present then
    return
  end

  vim.g.firenvim_config = {
    globalSettings = { alt = "all" },
    localSettings = {
      [".*"] = {
        cmdline = "neovim",
        content = "text",
        priority = 0,
        selector = "textarea",
        takeover = "never",
      },
    },
  }
end

M.pantran = function()
  local present, pantran = pcall(require, "pantran")

  if not present then
    return
  end

  local options = { -- TODO: configure it
  }

  pantran.setup(options)
end

M.ltex_extra = {
  load_langs = { "es" }, -- languages for witch dictionaries will be loaded
  init_check = true, -- load dictionaries on startup
  path = vim.fn.stdpath "config" .. "/spell", -- where to store dictionaries. relative = from cwd
  log_level = "none",
  on_attach = function(client, bufnr)
    require("configs.lspconfig").on_attach(client, bufnr)
  end,
  server_opts = {
    settings = {
      ["ltex"] = {
        enabled = true,
        language = "es",
        checkFrequency = "save", -- edit, save, manual
      },
    },
  },
}

M.template_nvim = {
  temp_dir = vim.fn.stdpath "config" .. "lua/templates/",
  author = "Pablo Avilés Mogío",
  email = "",
}

return M
