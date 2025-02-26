---@type MappingsTable
-- n, v, i, t = mode names

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- function that creates a neorg file called "README.neorg" in current file directory
-- if it already exists, it opens it
local function edit_neorg_file(file)
  local root_dir = vim.loop.cwd()
  local neorg_file = root_dir .. "/" .. file .. ".norg"
  vim.cmd("edit " .. neorg_file)
end

-- function that prints definition of a word under cursor
local function define_word()
  local word = vim.fn.expand "<cword>"
  vim.api.nvim_exec("!node ~/scripts/js/rae/rae.js " .. word, false)
end

-- function that creates a file in /tmp/ and opens it
local function create_tmp_file()
  local tmp_file = "/tmp/" .. os.date "%Y-%m-%d_%H-%M-%S" .. ".txt"
  vim.cmd("edit " .. tmp_file)
end

-- function that gets visual selection as a string
local function get_visual()
  local _, ls, cs = unpack(vim.fn.getpos "v")
  local _, le, ce = unpack(vim.fn.getpos ".")
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1]
end

local function toggle_lsp_lines()
  vim.g.lines_enabled = not vim.g.lines_enabled
  vim.diagnostic.config { virtual_lines = vim.g.lines_enabled, virtual_text = not vim.g.lines_enabled }
end

-- local search_in_firefox = [[<ESC>gv"gy<ESC>:lua os.execute("firefox --search '" .. vim.fn.getreg("g") .. "'") <CR>]]
-- local link_in_firefox = [[<ESC>gv"gy<ESC>:lua os.execute("firefox '" .. vim.fn.getreg("g") .. "'") <CR>]]
local function firefox_link()
  local link = get_visual()
  if link:match "^http" then
    vim.cmd("silent !firefox " .. link)
  else
    vim.cmd("silent !firefox --search " .. link)
  end
end

local function harpoon_mapping()
  local count = vim.v.count1
  if not count then
    require("harpoon.mark").add_file()
  else
    require("harpoon.ui").nav_file(count)
  end
end

local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },

    -- navigate within insert mode
    -- ["<C-h>"] = { "<Left>", "move left" },
    -- ["<C-l>"] = { "<Right>", "move right" },
    -- ["<C-j>"] = { "<Down>", "move down" },
    -- ["<C-k>"] = { "<Up>", "move up" },
  },

  n = {
    ["<ESC>"] = { "<cmd> noh <CR>", "no highlight" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "window left" },
    ["<C-l>"] = { "<C-w>l", "window right" },
    ["<C-j>"] = { "<C-w>j", "window down" },
    ["<C-k>"] = { "<C-w>k", "window up" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

    -- line numbers
    ["<leader>nu"] = { "<cmd> set nu! <CR>", "toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

    -- update nvchad
    -- ["<leader>uu"] = { "<cmd> :NvChadUpdate <CR>", "update nvchad" },

    ["<leader>tt"] = {
      function()
        require("base46").toggle_theme()
      end,
      "toggle theme",
    },

    ["<leader>as"] = { "<cmd> AutosaveToggle <CR>", "toggle autosave" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move up", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move down", opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },

    ["n"] = { "nzzzv", "center screen on n" },
    ["N"] = { "Nzzzv", "center screen on N" },
    ["<C-d>"] = { "<C-d>zz", "center screen on c-d" },
    ["<C-u>"] = { "<C-u>zz", "center screen on c-u" },

    ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },

    ["<leader>fm"] = { "<cmd> lua vim.lsp.buf.format()<CR>", "format buffer" },

    -- ["<leader>pv"] = { vim.cmd.Ex, "file explorer netrw" },
    ["<leader>e"] = { "<cmd> Oil <CR>", "file explorer Oil" },

    ["<leader>mr"] = { "<cmd>CellularAutomaton make_it_rain<CR>", "make code rain" },
    ["<leader>gl"] = { "<cmd>CellularAutomaton game_of_life<CR>", "game of life" },
    ["<leader>pr"] = { "<cmd> VimBeGood <CR>", "vimbegood games" },

    ["<leader><leader>"] = { vim.cmd.so, "source current file" },
    ["<leader>ps"] = { "<cmd> PackerSync <CR>", "packer sync" },

    ["<leader>sr"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "search and replace current word" },
    ["<leader>mx"] = { "<cmd>!chmod +x %<CR>", "make current file executable", opts = { silent = true } },

    ["<leader>co"] = { "<cmd> copen <CR>", "open quickfix window" },

    ["<leader>j"] = { harpoon_mapping, "harpoon" },
  },

  t = { ["<C-x>"] = { termcodes "<C-\\><C-N>", "escape terminal mode" } },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    -- Copy selected text
    ["<C-c>"] = { '"+y', "copy selected text" },

    -- search visual selection in firefox
    ["<leader>f"] = { firefox_link, "search visual selection in firefox", opts = { expr = true, silent = true } },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    -- ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
  },
  s = {
    ["<BS>"] = { "<C-g>s", "delete selection and enter insert mode" },
    ["<C-l>"] = { "<C-g><ESC>`>a", "delete selection and enter insert mode" },
  },
}

M.lazy = {
  n = {
    ["<leader>l"] = { "<cmd> Lazy <CR>", "lazy package manager window" },
    ["<leader>ls"] = { "<cmd> Lazy sync <CR>", "sync plugins" },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<A-.>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },

    ["<A-,>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },

    -- pick buffers via numbers
    ["<leader>pb"] = { "<cmd> TbufPick <CR>", "pick buffer" },

    -- close buffer + hide terminal buffer
    ["<leader>x"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      "close buffer",
    },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "lsp declaration",
    },

    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "lsp definition",
    },

    ["<leader>lh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "lsp hover",
    },

    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },

    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },

    ["<leader>D"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "lsp definition type",
    },

    ["<leader>ra"] = {
      function()
        require("nvchad_ui.renamer").open()
      end,
      "lsp rename",
    },

    ["<C- >"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "lsp code_action",
    },

    ["gr"] = {
      function()
        vim.lsp.buf.references()
      end,
      "lsp references",
    },

    ["<leader>f"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "goto prev",
    },

    ["d]"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "goto_next",
    },

    ["<leader>q"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "diagnostic setloclist",
    },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "lsp formatting",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "add workspace folder",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "list workspace folders",
    },

    -- navigation menu
    ["<leader>nb"] = {
      function()
        vim.lsp.diagnostic.goto_prev { popup_opts = { border = "rounded" } }
      end,
      "lsp diagnostic prev",
    },

    ["<leader>nf"] = {
      function()
        vim.lsp.diagnostic.goto_next { popup_opts = { border = "rounded" } }
      end,
      "lsp diagnostic next",
    },

    ["<leader>na"] = { "<cmd> Navbuddy <CR>", "navbuddy navigation menu" },
  },
}

-- M.nvimtree = {
--   plugin = true,
--
--   n = {
--     -- toggle
--     ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
--
--     -- focus
--     ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
--   },
-- }

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fc"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "grep current buffer" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },

    -- git
    ["<leader>fgc"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "nvchad themes" },

    -- extensions & extra
    ["<leader>tc"] = { "<cmd> TodoTelescope <CR>", "telescope todo comments" },
    ["<leader>tt"] = { "<cmd> TodoTrouble <CR>", "todo comments in trouble" },
    ["<leader>sn"] = { "<cmd> Telescope luasnip <CR>", "telescope snippets" },
    ["<leader>tu"] = { "<cmd> Telescope undo <CR>", "telescope undo history" },
    ["<leader>tq"] = { "<cmd> Telescope quickfix <CR>", "telescope quickfix" },
    ["<leader>gi"] = { "<cmd> Gitignore <CR>", "create gitignore template" },
  },
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "toggle vertical term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "toggle vertical term",
    },

    -- new

    ["<leader>h"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "new horizontal term",
    },

    ["<leader>v"] = {
      function()
        require("nvterm.terminal").new "vertical"
      end,
      "new vertical term",
    },
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd "WhichKey"
      end,
      "which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input "WhichKey: "
        vim.cmd("WhichKey " .. input)
      end,
      "which-key query lookup",
    },
  },
}

M.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      "jump to current_context",
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>rh"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "reset hunk",
    },

    ["<leader>ph"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "blame line",
    },

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "toggle deleted",
    },
  },
}

M.lazygit = {
  n = {
    ["<leader>gg"] = { "<cmd> LazyGit <CR>", "lazygit" },
    ["<leader>gb"] = { "<cmd> LazyGitCurrentFile <CR>", "lazygit in project root of current buffer" },
    ["<leader>gc"] = { "<cmd> LazyGitFilter <CR>", "lazygit commits" },
    ["<leader>gd"] = { "<cmd> LazyGitFilterCurrentFile <CR>", "lazygit commits for current buffer" },
  },
}

M.luasnip = {
  plugin = true,
  i = {
    ["<C-n>"] = {
      function()
        vim.fn.feedkeys(termcodes "<Plug>luasnip-next-choice")
      end,
      "next choice",
    },

    ["<C-p>"] = {
      function()
        vim.fn.feedkeys(termcodes "<Plug>luasnip-prev-choice")
      end,
      "prev choice",
    },
  },

  s = {
    ["<C-n>"] = {
      function()
        vim.fn.feedkeys(termcodes "<Plug>luasnip-next-choice")
      end,
      "next choice",
    },

    ["<C-p>"] = {
      function()
        vim.fn.feedkeys(termcodes "<Plug>luasnip-prev-choice")
      end,
      "prev choice",
    },
  },

  n = {
    ["<leader>se"] = {
      function()
        require "dressing"
        require("luasnip.loaders").edit_snippet_files()
      end,
      "edit luasnip snippets (with reload)",
    },
  },

  v = {},
}

-- for any register on the fly snippets
for letter in ("abcdefghijklmnopqrstuvwxyz"):gmatch "." do
  M.luasnip.i["<C-j>" .. letter] = {
    "<cmd>lua require('luasnip.extras.otf').on_the_fly('" .. letter .. "')<cr>",
    "luasnip on the fly",
  }
  M.luasnip.v["<C-j>" .. letter] = {
    '"' .. letter .. [[c <cmd>lua require('luasnip.extras.otf').on_the_fly("]] .. letter .. [[")<cr>]],
    "luasnip on the fly",
  }
end

M.zenmode = {
  plugin = true,
  n = {
    ["<leader>z"] = { "<cmd> ZenMode <CR>", "toggle zen mode" },
  },
}

M.treesitter = {
  plugin = true,
  n = {
    ["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", "treesitter capture under cursor" },
    ["K"] = {
      function()
        require("ts-node-action").node_action()
      end,
      "Trigger Node Action",
    },
  },
  x = {
    ["iu"] = { ':<c-u>lua require"treesitter-unit".select()<CR>', "select inner unit" },
    ["au"] = { ':<c-u>lua require"treesitter-unit".select(true)<CR>', "select outer unit" },
  },
  o = {
    ["iu"] = { ':<c-u>lua require"treesitter-unit".select()<CR>', "select inner unit" },
    ["au"] = { ':<c-u>lua require"treesitter-unit".select(true)<CR>', "select outer unit" },
  },
}

M.markdownpreview = {
  plugin = true,
  n = {
    ["<leader>mp"] = { "<cmd> MarkdownPreviewToggle <CR>", "toggle markdown preview" },
  },
}

M.icon_picker = {
  plugin = true,
  n = {
    ["<leader>pii"] = { "<cmd> IconPickerInsert <CR>", "pick icon for insert mode" },
    ["<leader>pin"] = { "<cmd> IconPickerNormal <CR>", "pick icon for normal mode" },
    ["<leader>piy"] = { "<cmd> IconPickerYank <CR>", "pick icon and yank it" },
  },
}

M.color_picker = {
  plugin = true,
  n = {
    ["<leader>pc"] = { "<cmd> PickColor <CR>", "pick color" },
    ["<leader>pci"] = { "<cmd> PickColorInsert <CR>", "pick color" },
  },
}

M.copilot = {
  plugin = true,
  n = {
    -- chat
    ["<leader>ch"] = { "<cmd> CopilotChatToggle <CR>", "CopilotChat > Toggle" },
    ["<leader>cn"] = {
      function()
        require("CopilotChat").reset()
        require("CopilotChat").open()
      end,
      "CopilotChat > New window",
    },
    ["<leader>cm"] = { "<cmd> CopilotChatModels <CR>", "CopilotChat > Select Models" },
    ["<leader>cp"] = {
      function()
        local actions = require "CopilotChat.actions"
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      end,
      "CopilotChat > Actions Menu",
    },
    ["<leader>cq"] = {
      function()
        require("CopilotChat").reset()
        local input = vim.fn.input "Quick Chat: "
        if input ~= "" then
          input = "@copilot /NormalPrompt " .. input
          require("CopilotChat").ask(input)
        end
      end,
      "CopilotChat > Quick Chat",
    },
    ["<leader>ct"] = {
      function()
        require("CopilotChat").reset()
        local prompts = require("CopilotChat").prompts()
        require("CopilotChat").open {
          system_prompt = prompts.TranslatorPrompt.system_prompt,
        }
      end,
      "CopilotChat > Translator",
    },
    ["<leader>cx"] = {
      function()
        return require("CopilotChat").reset()
      end,
      "CopilotChat > Clear",
    },
    ["<leader>cs"] = {
      function()
        require("CopilotChat").reset()
        require("CopilotChat").open {
          model = "claude-3.5-sonnet",
        }
      end,
      "CopilotChat > Claude Sonnet Model",
    },
  },
  v = {
    ["<leader>ch"] = { "<cmd> CopilotChat <CR>", "CopilotChat > Visual Selection" },
    ["<leader>co"] = { "<cmd> CopilotChat/Optimize <CR>", "CopilotChat > Optimize code selection" },
    ["<leader>cf"] = { "<cmd> CopilotChat/Fix <CR>", "CopilotChat > Fix code selection" },
    ["<leader>ce"] = { "<cmd> CopilotChat/Explain <CR>", "CopilotChat > Explain code selection" },
    ["<leader>cx"] = {
      function()
        return require("CopilotChat").reset()
      end,
      "CopilotChat > Clear",
    },
    ["<leader>ct"] = {
      function()
        require("CopilotChat").ask "@copilot /TranslatorPrompt Translate this."
      end,
      "CopilotChat > Translator",
    },
  },
}

M.dap = {
  plugin = true,

  n = {
    ["<leader>db"] = { "<cmd> lua require'dap'.toggle_breakpoint()<CR>", "dap: toggle breakpoint" },
    ["<leader>dc"] = { "<cmd> lua require'dap'.continue()<CR>", "dap: continue" },
    ["<leader>di"] = { "<cmd> lua require'dap'.step_into()<CR>", "dap: step into" },
    ["<leader>dr"] = { "<cmd> lua require'dap'.repl.open()<CR>", "dap: open repl" },

    --dapui
    ["<leader>do"] = { "<cmd> lua require'dapui'.open()<CR>", "dap: open dap ui" },
  },
}

M.code_runner = {
  plugin = true,
  -- stylua: ignore
  n = {
    ["<leader>r"] = { "<cmd> RunCode <CR>", "run code", opts = { noremap = true, silent = false } },
    ["<leader>rf"] = { "<cmd> RunFile <CR>", "run file", opts = { noremap = true, silent = false } },
    ["<leader>rft"] = { "<cmd> RunFile tab<CR>", "run file in tab", opts = { noremap = true, silent = false } },
    ["<leader>rp"] = { "<cmd> RunProject <CR>", "run project", opts = { noremap = true, silent = false } },
    ["<leader>rc"] = { "<cmd> RunClose <CR>", "run window", opts = { noremap = true, silent = false } },
    ["<leader>crf"] = {
      "<cmd> CRFiletype <CR>",
      "run code by filetype",
      opts = { noremap = true, silent = false },
    },
    ["<leader>crp"] = {
      "<cmd> CRProjects <CR>",
      "run code by project",
      opts = { noremap = true, silent = false },
    },
  },
}

M.qol = {
  n = {
    ["<leader>tmp"] = {
      function()
        create_tmp_file()
      end,
      "create tmp file",
    },
  },
}

M.sniprun = {
  n = {
    ["<leader>sc"] = { "<cmd> SnipRun <CR>", "sniprun run selected code" },
  },
  v = {
    ["<leader>sc"] = { "<cmd> SnipRun <CR>", "sniprun run selected code" },
  },
}

M.ufo = {
  plugin = true,
  n = {
    ["zR"] = { "<cmd> lua require('ufo').openAllFolds() <CR>", "open all folds" },
    ["zM"] = { "<cmd> lua require('ufo').closeAllFolds() <CR>", "close all folds" },
  },
}

M.neorg = {
  plugin = true,
  n = {
    ["<leader>ne"] = { "<cmd> Neorg <CR>", "neorg main command" },
    ["<leader>nf"] = {
      function()
        edit_neorg_file "README"
      end,
      "neorg create or edit readme file",
    },
    -- todo
    ["<leader>nt"] = {
      function()
        edit_neorg_file "todo"
      end,
      "neorg create or edit todo file",
    },
  },
}

local open_latex_file = function()
  local line = vim.fn.getline "."
  local file = line:match "\\input{(.-)}"
  if file then
    if not file:match "%.%w+$" then
      file = file .. ".tex"
    end
    vim.cmd("e " .. file)
  end
end
local grep_string = function(title, string)
  require("telescope.builtin").grep_string {
    search = string,
    prompt_title = title,
  }
end
M.latex = {
  plugin = true, -- lazy load mappings
  n = {
    ["<leader>tex"] = {
      "<cmd> lua embed_latex() <CR>",
      "open latex panel",
      opts = { noremap = true, silent = true },
    },
    ["<leader>lb"] = {
      "<cmd> Telescope bibtex format='tex' <CR>",
      "telescope bibtex entries",
      opts = { noremap = true, silent = true },
    },
    ["<leader>le"] = {
      function()
        grep_string("Search Equation", "\\label{eq:")
      end,
      "search equations by label",
    },
    ["<leader>lf"] = {
      function()
        grep_string("Search Figure", "\\label{fig:")
      end,
      "search figures by label",
    },
    ["<leader>lt"] = {
      function()
        grep_string("Search Figure", "\\label{tab:")
      end,
      "search tables by label",
    },
    ["<leader>lo"] = { open_latex_file, "open latex file" },
  },
  i = {
    ["<C-l>"] = {
      "<C-g>u<Esc>[s1z=`]a<C-g>u",
      "fix last miss-spelling",
      opts = { noremap = true, silent = true },
    },
  },
  -- NOTE: this should be remove after TFG
  -- v = {
  --   -- leader + l: add line before "a" and line after "b"
  --   ["<leader>c"] = {
  --     function()
  --       local _, ls, _ = unpack(vim.fn.getpos "'<")
  --       local _, le, _ = unpack(vim.fn.getpos "'>")
  --       local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  --       local new_lines = {}
  --       table.insert(new_lines, "\\begin{minted}{wolfram}")
  --       for _, line in ipairs(lines) do
  --         table.insert(new_lines, line)
  --       end
  --       table.insert(new_lines, "\\end{minted}")
  --       table.insert(new_lines, "\\betweenminted{.9\\bigskipamount}")
  --       vim.api.nvim_buf_set_lines(0, ls - 1, le, false, new_lines)
  --     end,
  --     "convert lines to mathematica code",
  --   },
  --   -- leader + o: same but before each line add ">>> "
  --   ["<leader>o"] = {
  --     function()
  --       local _, ls, _ = unpack(vim.fn.getpos "'<")
  --       local _, le, _ = unpack(vim.fn.getpos "'>")
  --       local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  --       local new_lines = {}
  --       table.insert(new_lines, "\\betweenminted{1.5\\bigskipamount}")
  --       table.insert(new_lines, "\\begin{lstlisting}[language={}]")
  --       for _, line in ipairs(lines) do
  --         table.insert(new_lines, ">>> " .. line)
  --       end
  --       vim.api.nvim_buf_set_lines(0, ls - 1, le, false, new_lines)
  --       table.insert(new_lines, "\\end{lstlisting}")
  --       table.insert(new_lines, "\\betweenminted{1.5\\bigskipamount}")
  --     end,
  --     "convert lines to mathematica code",
  --   },
  -- },
  -- -- same in visual block mode
  -- x = {
  --   ["<leader>c"] = {
  --     function()
  --       local _, ls, _ = unpack(vim.fn.getpos "'<")
  --       local _, le, _ = unpack(vim.fn.getpos "'>")
  --       local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  --       local new_lines = {}
  --       table.insert(new_lines, "\\begin{minted}{wolfram}")
  --       for _, line in ipairs(lines) do
  --         table.insert(new_lines, line)
  --       end
  --       table.insert(new_lines, "\\end{minted}")
  --       table.insert(new_lines, "\\betweenminted{.9\\bigskipamount}")
  --       vim.api.nvim_buf_set_lines(0, ls - 1, le, false, new_lines)
  --     end,
  --     "convert lines to mathematica code",
  --   },
  --   ["<leader>o"] = {
  --     function()
  --       local _, ls, _ = unpack(vim.fn.getpos "'<")
  --       local _, le, _ = unpack(vim.fn.getpos "'>")
  --       local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  --       local new_lines = {}
  --       table.insert(new_lines, "\\betweenminted{1.5\\bigskipamount}")
  --       table.insert(new_lines, "\\begin{lstlisting}[language={}]")
  --       for _, line in ipairs(lines) do
  --         table.insert(new_lines, ">>> " .. line)
  --       end
  --       vim.api.nvim_buf_set_lines(0, ls - 1, le, false, new_lines)
  --       table.insert(new_lines, "\\end{lstlisting}")
  --       table.insert(new_lines, "\\betweenminted{1.5\\bigskipamount}")
  --     end,
  --     "convert lines to mathematica code",
  --   },
  -- },
}

M.airlatex = {
  n = {
    ["<leader>la"] = { "<cmd> AirLatex <CR>", "airlatex panel" },
  },
}

local open_typst_file = function()
  local line = vim.fn.getline "."
  local file = line:match '#include "(.-).typ"'
  if file then
    vim.cmd("e " .. file .. ".typ")
  end
end
M.typst = {
  plugin = true, -- lazy load mappings
  n = {
    ["<leader>ll"] = {
      function()
        vim.cmd "silent! TypstPreviewToggle"
        -- vim.cmd "silent! TypstWatch"
      end,
      "compile typst file",
      opts = { noremap = true, silent = true },
    },
    ["<leader>lv"] = {
      function()
        -- find parent dir
        local str = ""
        local parent_dir = vim.fn.fnamemodify(vim.fn.expand "%:p:h", ":t")
        local parent_dir_of_parent = vim.fn.fnamemodify(vim.fn.expand "%:p:h:h", ":t")
        if parent_dir:match "practica" or parent_dir_of_parent:match "semestre" then
          str = " --root ../"
        end
        -- find main file and replace .typ with .pdf
        local main_file_typ = vim.fn.FindMainFile()
        local main_file_pdf = main_file_typ:gsub("%.typ$", ".pdf")
        require("nvterm.terminal").send("typst watch '" .. main_file_typ .. "'" .. str, "horizontal")
        require("nvterm.terminal").toggle "horizontal"
        -- os.execute("xdg-open '" .. main_file_pdf .. "' &")
        os.execute("zathura '" .. main_file_pdf .. "' &")
      end,
      "compile typst file",
      opts = { noremap = true, silent = true },
    },
    ["<leader>lo"] = { open_typst_file, "open typst file" },
  },
  i = {
    ["<C-l>"] = {
      "<C-g>u<Esc>[s1z=`]a<C-g>u",
      "fix last miss-spelling",
      opts = { noremap = true, silent = true },
    },
  },
}

M.webtools = {
  plugin = true,
  n = {
    ["<leader>wo"] = { "<cmd> BrowserOpen <CR>", "open website in browser" },
  },
}

M.dictionary = {
  n = {
    ["<leader>dw"] = {
      function()
        define_word()
      end,
      "define word using rae dictionary",
    },
  },
}

M.lsp_lines = {
  -- plugin = true,
  n = {
    ["<leader>tll"] = {
      function()
        toggle_lsp_lines()
      end,

      "toggle lsp lines diagnostics",
    },
  },
}

M.muren = {
  n = {
    ["<leader>mt"] = { "<cmd> MurenToggle <CR>", "toggle muren panel" },
    ["<leader>mf"] = { "<cmd> MurenFresh <CR>", "open muren fresh (clear previous)" },
    ["<leader>mu"] = { "<cmd> MurenUnique <CR>", "open muren with latest search in buffer" },
  },
}

M.various_textobjs = {
  plugin = true,
  o = {
    ["aS"] = { '<cmd>lua require("various-textobjs").subword("outer")<CR>', "subword outer" },
    ["iS"] = { '<cmd>lua require("various-textobjs").subword("inner")<CR>', "subword inner" },

    ["in"] = { '<cmd>lua require("various-textobjs").number("inner")<CR>', "number inner" },
    ["an"] = { '<cmd>lua require("various-textobjs").number("outer")<CR>', "number outer" },
  },
  x = {
    ["aS"] = { '<cmd>lua require("various-textobjs").subword("outer")<CR>', "subword outer" },
    ["iS"] = { '<cmd>lua require("various-textobjs").subword("inner")<CR>', "subword inner" },

    ["in"] = { '<cmd>lua require("various-textobjs").number("inner")<CR>', "number inner" },
    ["an"] = { '<cmd>lua require("various-textobjs").number("outer")<CR>', "number outer" },
  },
}

return M
