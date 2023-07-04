-- function that formats latex text
function formatLatex()
  -- replace all consecutive spaces with a single space
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":%s/ \\+/ /g<CR>", true, true, true), "n", true)

  -- replace {"text" } with {"text"}
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":%s/{\\(.\\{-}\\) }/{\\1}/g<CR>", true, true, true), "n", true)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":%s/ )/)/g<CR>", true, true, true), "n", true)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":%s/ ]/]/g<CR>", true, true, true), "n", true)
  vim.cmd "lua vim.lsp.buf.format()" -- format the file
end
