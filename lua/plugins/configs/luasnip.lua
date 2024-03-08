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
    local filetypes = require("luasnip.extras.filetype_functions").from_pos_or_filetype()
    local replace = { -- for some edge cases where the function returns the wrong filetype
      latex = "tex",
      bash = "sh",
      bibtex = "bib",
      markdown_inline = "markdown",
    }
    if utils.is_snippets_snips_file() and filetypes[1] == "lua" then
      return { "lua", "luasnips" }
    end
    for not_working, working in ipairs(filetypes) do -- replace latex with tex, etc.
      if replace[working] then
        filetypes[not_working] = replace[working]
      end
    end
    -- EXTRA
    if vim.fn.expand("%:p:h"):find(os.getenv "HOME" .. "/.config/awesome/bindings") then
      return { "lua", "awesome" }
    end
    --
    return filetypes
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
    config .. "/lua/luasnippets",
    "~/Documentos/Universidad/Apuntes/curso_actual", -- À la Gilles
    "~/Documentos/Universidad/modo_actual",
  },
}

require("luasnip.loaders.from_snipmate").lazy_load {
  paths = { config .. "/lua/luasnippets/snippets" },
}

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
