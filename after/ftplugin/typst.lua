require("core.utils").load_mappings "typst"

vim.opt_local.spelllang = "es"
vim.opt_local.conceallevel = 0
vim.opt_local.spell = true

-- vim.g.typst_pdf_viewer = "sioyek"
vim.g.typst_conceal_math = false
vim.g.typst_no_editor = true -- custom: don't open editor

vim.cmd "silent! C"

vim.g.backupcopy = true -- so that typst watch doesnt fail on save

-- local _, bufname = pcall(vim.api.nvim_buf_get_name, 0)
-- local names = {
--   "master.typ",
--   "main.typ",
-- }
--
-- for _, name in ipairs(names) do
--   if vim.endswith(bufname, name) then
--     vim.cmd "silent! TypstWatch"
--   end
-- end
