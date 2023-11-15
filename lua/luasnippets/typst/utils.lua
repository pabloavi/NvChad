local M = {}

-- line is an import (begins with #import)
M.in_import = function()
  local line = vim.api.nvim_get_current_line()
  return string.find(line, "^#import") ~= nil
end

M.in_template = function()
  -- check current file name for template.typ
  local file = vim.fn.expand "%:t"
  if file == "template.typ" then
    return true
  end
end

M.in_text = function()
  return not M.in_import() and not M.in_mathzone() and not M.in_comment() and not M.in_code()
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
