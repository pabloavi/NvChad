local present, luasnip = pcall(require, "luasnip")

if not present then
  return
end

local utils = require "core.utils"
local config = vim.fn.stdpath "config"

local options = {
  history = true,
  enable_autosnippets = true,
  updateevents = "TextChanged,TextChangedI",
  ft_func = function()
    local ft = require("luasnip.extras.filetype_functions").from_pos_or_filetype()
    local replace = { -- for some edge cases where the function returns the wrong filetype
      latex = "tex",
      bash = "sh",
      bibtex = "bib",
    }
    if utils.is_snippets_snips_dir() then
      return { "lua", "luasnips" }
    end
    for i, v in ipairs(ft) do -- replace latex with tex, etc.
      if replace[v] then
        ft[i] = replace[v]
      end
    end
    return ft
  end,
  load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft {
    markdown = { "lua", "json", "python", "rust", "tex" },
    norg = { "lua", "python", "rust", "tex" },
    lua = { "lua", "luasnips" },
  },
}

luasnip.config.set_config(options)
-- FIX: remove this when forked friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load {
  paths = config .. "/lua/luasnippets/friendly-snippets",
}

require("luasnip.loaders.from_lua").lazy_load {
  paths = {
    "~/.config/nvim/lua/luasnippets",
    "~/Documentos/Universidad/Apuntes/curso_actual", -- À la Gilles
  },
}

-- require("luasnip/loaders/from_snipmate").lazy_load()

-- remove snippets when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})
