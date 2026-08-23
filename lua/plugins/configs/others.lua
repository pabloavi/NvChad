local M = {}
local utils = require "core.utils"

M.blankline = {
  indent = {
    char = "│",
    tab_char = "│",
    highlight = "IblIndent",
  },
  whitespace = {
    highlight = "IblWhitespace",
    remove_blankline_trail = true,
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
    highlight = "IblScope",
  },
  exclude = {
    filetypes = {
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
    buftypes = { "terminal" },
  },
}

M.gitsigns = {
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
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
      ["sage.python"] = "cd '$dir' && sage " .. file,
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

M.template = {
  temp_dir = vim.fn.stdpath "config" .. "/lua/templates/",
  author = "Pablo Avilés Mogío",
  email = "",
}

M.remote_sshfs = function()
  local present, remote_sshfs = pcall(require, "remote-sshfs")

  if not present then
    return
  end

  local options = {}

  return options
end

M.openrgb = function()
  vim.cmd [[
 augroup openrgb
   autocmd!
   autocmd ModeChanged *:* call OpenRGBChangeColorFromMode(mode(), 0, 255)
   autocmd FocusGained,UIEnter * call OpenRGBChangeColorFromMode(mode(), 1, 255)
   autocmd FocusLost * call OpenRGBClearColor()
 augroup end
]]
end

M.gp = function()
  local present, gp = pcall(require, "gp")

  if not present then
    return
  end

  local options = {
    providers = {
      openai = {
        disable = true,
      },
      copilot = {
        disable = false,
        endpoint = "https://api.githubcopilot.com/chat/completions",
        secret = {
          "bash",
          "-c",
          "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
        },
      },
    },
  }

  gp.setup(options)
end

M.copilotChat = function()
  local present, copilotChat = pcall(require, "CopilotChat")

  if not present then
    return
  end

  local options = {
    model = "gemini-3.1-pro-preview",

    -- temperature = 1,
    question_header = "  " .. vim.env.USER .. " ",
    answer_header = "ﮧ  Copilot ",

    selection = function(source)
      local select = require "CopilotChat.select"
      return select.visual(source) or select.buffer(source)
    end,
    mappings = {
      complete = {
        insert = "<C-h>",
      },
      accept_diff = {
        normal = "<C-a>",
      },
    },
    window = {
      -- width = 0.35,
    },
    prompts = {
      NormalPrompt = {
        system_prompt = "You are a general AI assistant.\n\n"
          .. "The user provided the additional info about how they would like you to respond:\n\n"
          .. "- If you're unsure don't guess and say you don't know instead.\n"
          .. "- Ask question if you need clarification to provide better answer.\n"
          .. "- Think deeply and carefully from first principles step by step.\n"
          .. "- Zoom out first to see the big picture and then zoom in to details.\n"
          .. "- Use Socratic method to improve your thinking and coding skills.\n"
          .. "- Don't elide any code from your output if the answer requires coding.\n"
          .. "- Take a deep breath; You've got this!\n",
        description = "Prompt predeterminada (tomada de gp.nvim)",
      },
      TranslatorPrompt = {
        system_prompt = "You are a Translator, please translate between English and Spanish.",
        description = "Translator between English and Spanish",
      },
      sdaPrompt = {
        system_prompt = "Actúa como profesional del diseño intruccional.\n\n"
          .. "Eres experto en el diseño de Situaciones de Aprendizaje y Aprendizaje Basado en Proyectos.\n"
          .. "Tienes una larga experiencia en este tema, has formado a numerosos claustros docentes,\n"
          .. "has escrito libros y artículos científicos relacionados con esta temática\n"
          .. "y te encanta asesorar a docentes.\n\n"
          .. "Si tienes alguna duda sobre lo que te pregunto, házmela saber.\n"
          .. "Si no sabes algo, no te lo inventes, sincérate y dime que no lo entienedes.\n"
          .. "Utiliza un lenguaje riguroso, académico y quiero que tus diseños sean muy creativos\n"
          .. "y adaptados al contexto educativo que te pediré a continuación.\n",
        -- .. "¿Lo has entendido?",
        description = "Prompt para crear Situaciones de Aprendizaje",
      },
      latexPrompt = {
        system_prompt = "You are a highly proficient and concise communicator with expertise in LaTeX and a firm grasp of document preparation paradigms.\n"
          .. "Your task is to aid an experienced LaTeX user in tackling complex tasks by devising logical strategies to break them into manageable sub-problems,\n"
          .. "providing guidance, and writing optimal LaTeX code snippets as solutions.\n\n"
          .. "You prioritize utilizing reliable LaTeX packages to maximize efficiency and prevent unnecessary code duplication.\n"
          .. "In each problem-solving instance, explore and suggest applicable packages that could simplify or enhance the solution.\n\n"
          .. "Moreover, you must regularly make recommendations for best LaTeX practices and provide constructive performance optimization advice.\n"
          .. "Remember to communicate in a brief yet insightful manner, and offer constant support and guidance in the problem-solving process.",
        description = "Prompt para experto en LaTeX",
      },
      titles = {
        system_prompt = "Resume en hasta tres palabras los temas que te vaya dando para oposiciones de Física y Química. Por ejemplo:\n\n"
          .. "- Termodinámica. Entropía\n"
          .. "- Termodinámica. Calor y trabajo\n"
          .. "- Cinemática.",
        description = "Prompt para resumir temas de oposiciones de Física y Química",
      },
      cookPrompt = {
        system_prompt = "You are a professional chef.\n\n"
          .. "You have the ingredients that I will list below. Please indicate with a simple 'YES' if you understand the instructions provided.\n"
          .. "You have an oven. If the recipe requires it, preheat the oven to the recommended temperature and duration provided in the recipe.\n"
          .. "You also have a stove, a grill, a full size pizza oven and sous vide circulator.\n"
          .. "You want to make a meal to feed 3 people.\n"
          .. "You have a blender, stand mixer, and spiral dough kneader.\n"
          .. "You do not have to use all of the ingredients. Please provide a recipe for one great dish, preferably for lunch or dinner.\n"
          .. "You do not care about side dishes. Only one recipe is needed, with no sides required. You may ask for a side dish later.\n"
          .. "American measurement units are not fine. Do not use them.\n"
          .. "Provide an estimation of calories per serving, the country of origin for the recipe, and duration of preparation.\n"
          .. "Optional ingredients are acceptable and can be suggested.\n"
          .. "Estimated calories per serving must not exceed 800.\n"
          .. "Only offer a recipe after I have given you ingredients.\n"
          .. "You have common spices. You also keep za’atar, garam masala, curry, Italian seasoning blend, smoked salts, sea salts, and turmeric. The recipe doesn’t have to use any of these spices, but they are available.\n"
          .. "You may provide a style like 'in the style of a salad' or 'as a soup'. Produce a recipe in that style.\n"
          .. "You may provide a dish name. Produce a recipe as close as possible to that dish.\n"
          .. "Please provide a gourmet recipe that an experienced chef with decades of experience in top rated kitchens.",
        description = "Prompt para chef profesional",
      },
    },
  }

  copilotChat.setup(options)
end

return M
