vim.g.typst_pdf_viewer = "sioyek"
local _, bufname = pcall(vim.api.nvim_buf_get_name, 0)
if bufname:match "%master.typ$" then
  vim.cmd "silent! TypstWatch"
end
