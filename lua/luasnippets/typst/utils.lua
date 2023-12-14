local M = {}

-- line is an import (begins with #import)
M.in_import = function()
  local line = vim.api.nvim_get_current_line()
  return string.find(line, "^#import") ~= nil
end

-- check current file name for template.typ
M.in_template = function()
  local file = vim.fn.expand "%:t"
  if file == "template.typ" then
    return true
  end
end

-- check curren file name for master.typ or main.typ
M.in_master = function()
  local file = vim.fn.expand "%:t"
  if file == "master.typ" or file == "main.typ" then
    return true
  end
end

M.in_text = function()
  -- return not M.in_import() and not M.in_mathzone() and not M.in_comment() and not M.in_code()
  return not M.in_import() and not M.in_mathzone() and not M.in_comment()
end

M.in_mathzone = function()
  return vim.fn["typst#in_math"]() == 1
end

M.in_comment = function()
  return vim.fn["typst#in_comment"]() == 1
end

M.in_code = function()
  return vim.fn["typst#in_code"]() == 1
end

M.in_markup = function()
  return vim.fn["typst#in_markup"]() == 1
end

return M
