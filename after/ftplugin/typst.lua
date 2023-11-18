require("core.utils").load_mappings "typst"

-- vim.g.typst_pdf_viewer = "sioyek"

vim.opt_local.spelllang = "es"
vim.opt_local.conceallevel = 0
vim.opt_local.spell = true
vim.g.typst_conceal_math = false

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
