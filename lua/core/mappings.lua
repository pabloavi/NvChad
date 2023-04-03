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

local function toggle_lsp_lines()
  vim.g.lines_enabled = not vim.g.lines_enabled
  vim.diagnostic.config { virtual_lines = vim.g.lines_enabled, virtual_text = not vim.g.lines_enabled }
end

local search_in_firefox = [[<ESC>gv"gy<ESC>:lua os.execute("firefox --search '" .. vim.fn.getreg("g") .. "'") <CR>]]

local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "move left" },
    ["<C-l>"] = { "<Right>", "move right" },
    ["<C-j>"] = { "<Down>", "move down" },
    ["<C-k>"] = { "<Up>", "move up" },
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

    -- TODO: remove toggle_theme
    -- ["<leader>tt"] = {
    --   function()
    --     require("base46").toggle_theme()
    --   end,
    --   "toggle theme",
    -- },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    ["n"] = { "nzzzv", "center screen on n" },
    ["N"] = { "Nzzzv", "center screen on N" },
    ["<C-d>"] = { "<C-d>zz", "center screen on c-d" },
    ["<C-u>"] = { "<C-u>zz", "center screen on c-u" },

    ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },

    ["<leader>fm"] = { "<cmd> lua vim.lsp.buf.format()<CR>", "format buffer" },

    ["<leader>pv"] = { vim.cmd.Ex, "file explorer netrw" },

    ["<leader>mr"] = { "<cmd>CellularAutomaton make_it_rain<CR>", "make code rain" },
    ["<leader>gl"] = { "<cmd>CellularAutomaton game_of_life<CR>", "game of life" },
    ["<leader>pr"] = { "<cmd> VimBeGood <CR>", "vimbegood games" },

    ["<leader><leader>"] = { vim.cmd.so, "source current file" },
    ["<leader>ps"] = { "<cmd> PackerSync <CR>", "packer sync" },

    ["<leader>sr"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "search and replace current word" },
    ["<leader>mx"] = { "<cmd>!chmod +x %<CR>", "make current file executable", opts = { silent = true } },
  },

  t = { ["<C-x>"] = { termcodes "<C-\\><C-N>", "escape terminal mode" } },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    -- search visual selection in firefox
    ["<leader>f"] = { search_in_firefox, "search visual selection in firefox", opts = { silent = true } },
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
    ["<C-i>"] = { "<C-g><ESC>`>a", "delete selection and enter insert mode" },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<TAB>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },

    ["<S-Tab>"] = {
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

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },

    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "nvchad themes" },

    -- extensions & extra
    ["<leader>tc"] = { "<cmd> TodoTelescope <CR>", "telescope todo comments " },
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
        -- vim.cmd "PackerLoad telescope.nvim"
        require "telescope"
        require "dressing"
        require("luasnip.loaders").edit_snippet_files()
      end,
      "edit luasnip snippets (with reload)",
    },
  },
}

M.truezen = {
  plugin = true,
  n = {
    ["<leader>ta"] = { "<cmd> TZAtaraxis <CR>", "truzen ataraxis" },
    ["<leader>tm"] = { "<cmd> TZMinimalist <CR>", "truzen minimal" },
    ["<leader>tf"] = { "<cmd> TZFocus <CR>", "truzen focus" },
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
}
-- these werent working as expected
vim.keymap.set("x", "iu", ':<c-u>lua require"treesitter-unit".select()<CR>')
vim.keymap.set("o", "iu", ':<c-u>lua require"treesitter-unit".select()<CR>')
vim.keymap.set("x", "au", ':<c-u>lua require"treesitter-unit".select(true)<CR>')
vim.keymap.set("o", "au", ':<c-u>lua require"treesitter-unit".select(true)<CR>')

M.markdownpreview = {
  plugin = true,
  n = {
    ["<leader>mp"] = { "<cmd> MarkdownPreviewToggle <CR>", "toggle markdown preview" },
  },
}

M.icon = {
  plugin = true,
  n = {
    ["<leader>ici"] = { "<cmd> IconPickerInsert <CR>", "pick icon for insert mode" },
    ["<leader>icn"] = { "<cmd> IconPickerNormal <CR>", "pick icon for normal mode" },
    ["<leader>icy"] = { "<cmd> IconPickerYank <CR>", "pick icon and yank it" },
  },
}

M.copilot = {
  plugin = true,
  n = {
    ["<leader>cp"] = { "<cmd> Copilot panel <CR>", "copilot panel" },
  },
}

M.dap = {
  plugin = true,

  n = {
    ["<leader>db"] = { "<cmd> lua require'dap'.toggle_breakpoint()<CR>", "dap: toggle breakpoint" },
    ["<leader>dc"] = { "<cmd> lua require'dap'.continue()<CR>", "dap: continue" },
    ["<leader>di"] = { "<cmd> lua require'dap'.step_into()<CR>", "dap: step into" },
    ["<leader>dr"] = { "<cmd> lua require'dap'.repl.open()<CR>", "dap: open repl" },
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
    ["<leader>ct"] = {
      function()
        create_tmp_file()
      end,
      "create tmp file",
    },
  },
}

M.sniprun = {
  plugin = true,
  n = {
    ["<leader>sr"] = { "<cmd> SnipRun <CR>", "sniprun run selected code" },
  },
  v = {
    ["<leader>sr"] = { "<cmd> SnipRun <CR>", "sniprun run selected code" },
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

M.latex = {
  plugin = true,
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
  },
}

M.airlatex = {
  n = {
    ["<leader>la"] = { "<cmd> AirLatex <CR>", "airlatex panel" },
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

return M
