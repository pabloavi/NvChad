local M = {}

function M.in_mathzone()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

function M.in_comment()
  return vim.fn["vimtex#syntax#in_comment"]() == 1
end

function M.in_text()
  return not M.in_mathzone() and not M.in_comment()
end

function M.in_env(env)
  return vim.fn["vimtex#syntax#is_inside"](env) == 1
end

return M
