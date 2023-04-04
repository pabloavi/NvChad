local options = {
  ensure_installed = {
    "vim",
    "vimdoc",
    -- "html",
    -- "css",
    -- "javascript",
    "json",
    "toml",
    "markdown",
    -- "c",
    "bash",
    "lua",
    "norg",
    "fortran",
    "python",
    -- "java",
    "latex",
    "bibtex",
    "rust",
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
        -- ["ac"] = { query = "@class.outer", desc = "select outer class" },
        -- ["ic"] = { query = "@class.inner", desc = "select inner class" },
      },
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      include_surrounding_whitespace = true,
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

  rainbow = {
    enable = true,
  },
}

return options
