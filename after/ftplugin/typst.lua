-- -- TODO: make these
-- require("nvim-surround").buffer_setup {
--   surrounds = {
--     ["_"] = {
--       add = function()
--         return { { "_" }, { "_" } }
--       end,
--       delete = "^(_)().-(_)()$",
--       change = {
--         target = "^(_)().-(_)()$",
--         replacement = function()
--           return { { "*", "\t" }, { "", "*" } }
--         end,
--       },
--     },
--     ["$"] = {
--       add = { "\\(", "\\)" },
--       find = "\\%(.-\\%)",
--       delete = "^(\\%()().-(\\%))()$",
--       change = {
--         target = "^\\(%()().-(\\%))()$",
--         replacement = function()
--           return { { "[", "\t" }, { "", "\\]" } }
--         end,
--       },
--     },
--   },
-- }
vim.g.typst_pdf_viewer = "sioyek"
local _, bufname = pcall(vim.api.nvim_buf_get_name, 0)
if bufname:match "%master.typ$" then
  vim.cmd "silent! TypstWatch"
end
