local present, luasnip = pcall(require, "luasnip")

if not present then
  return
end

local utils = require "core.utils"

local snippets_snips_dir = {
  "/home/pablo/.config/nvim/lua/luasnippets",
  "/home/pablo/.config/nvim/lua/luasnippets/luasnips",
}

local options = {
  history = true,
  enable_autosnippets = true,
  updateevents = "TextChanged,TextChangedI",
  ft_func = function()
    local ft = require("luasnip.extras.filetype_functions").from_pos_or_filetype()
    -- ft is a table. if it contains latex, replace it by tex
    for i, v in ipairs(ft) do
      if v == "latex" then
        ft[i] = "tex"
      end
    end
    return ft
  end,
  load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft {
    markdown = { "lua", "json", "python", "rust", "tex" },
    norg = { "lua", "python", "rust", "tex" },
  },
}

luasnip.config.set_config(options)
-- FIX: remove this when forked friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load {
  paths = "/home/pablo/.config/nvim/lua/luasnippets/friendly-snippets",
}

require("luasnip.loaders.from_lua").lazy_load()
require("luasnip.loaders.from_lua").lazy_load {
  paths = vim.g.luasnippets_path
    or {
      "~/.config/nvim/lua/luasnippets",
      "~/Documentos/Universidad/Apuntes/curso_actual", -- À la Gilles
      "~/.config/nvim/lua/luasnippets/temporal", -- FIX: bad position
    },
}

require("luasnip/loaders/from_snipmate").lazy_load()

-- load snippets for snippets only if in luasnippets dir or subdirs
local function is_snippets_snips_dir()
  local current_dir = vim.fn.expand "%:p:h"
  for _, dir in ipairs(snippets_snips_dir) do
    if current_dir:find(dir) then
      return true
    end
  end
  return false
end

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

-- add luasnips filetype to all files in snippets dir so that they are successfully loaded
vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
  pattern = "*.lua",
  callback = function()
    if is_snippets_snips_dir() then
      vim.bo.filetype = "lua.luasnips"
    end
  end,
})

-- TODO:
-- markdown code block
-- vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMoved" }, {
--   pattern = "*.md",
--   callback = function()
--     local cursor_filetype = require("luasnip.extras.filetype_functions").from_cursor_pos()[1]
--     require("luasnip").add_snippets(cursor_filetype, nil, {
--       key = "markdown_code_block",
--     })
--   end,
-- })
