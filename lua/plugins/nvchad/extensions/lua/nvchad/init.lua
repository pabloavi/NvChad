local M = {}
local fn = vim.fn

M.list_themes = function()
  local themes = vim.fn.readdir(vim.fn.stdpath "config" .. "/lua/plugins/nvchad/base46/lua/base46/themes")

  for index, theme in ipairs(themes) do
    themes[index] = fn.fnamemodify(fn.fnamemodify(theme, ":t"), ":r")
  end

  return themes
end

M.replace_word = function(old, new)
  local config = vim.fn.stdpath "config" .. "/lua/core/" .. "config.lua"
  local file = io.open(config, "r")
  local added_pattern = string.gsub(old, "-", "%%-") -- add % before - if exists
  local new_content = file:read("*all"):gsub(added_pattern, new)

  file = io.open(config, "w")
  file:write(new_content)
  file:close()
end

return M
