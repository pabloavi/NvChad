local options = {
  ensure_installed = {
    -- "vim",
    "vimdoc",
    "sxhkdrc",
    "json",
    "toml",
    "markdown",
    "bash",
    "lua",
    "norg",
    "fortran",
    "python",
    "latex",
    "bibtex",
    "rust",
    "rasi",
    "query",
    -- "hyprlang",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = {
    enable = true,
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- jump forward selection
      keymaps = { -- capture groups from textobjects.scm or locals.scm
        ["af"] = { query = "@function.outer", desc = "select outer function" },
        ["if"] = { query = "@function.inner", desc = "select inner function" },
        ["ac"] = { query = "@call_capture", desc = "select outer class" },
        ["a$"] = { query = "@math_capture", desc = "select outer class" },
        -- ["ac"] = { query = "@class.outer", desc = "select outer class" },
        -- ["ic"] = { query = "@class.inner", desc = "select inner class" },
        ["as"] = { query = "@scope", query_group = "locals", desc = "select language scope" },
      },
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      include_surrounding_whitespace = true,
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>sl"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>sh"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      },
    },
  },

  textsubjects = {
    enable = true,
    prev_selection = ",", -- select the previous selection
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
-- parser_config.hypr = {
--   install_info = {
--     url = "https://github.com/luckasRanarison/tree-sitter-hypr",
--     files = { "src/parser.c" },
--     branch = "master",
--   },
--   filetype = "hyprlang",
-- }
parser_config.typst = {
  install_info = {
    url = "https://github.com/uben0/tree-sitter-typst.git", -- local path or git repo
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "typst", -- if filetype does not match the parser name
}

if vim.g.c_enabled then
  table.insert(options.ensure_installed, { "c", "cpp" })
end

if vim.g.java_enabled then
  table.insert(options.ensure_installed, "java")
end

if vim.g.webdev_enabled then
  table.insert(options.ensure_installed, { "html", "css", "javascript" })
end

return options
