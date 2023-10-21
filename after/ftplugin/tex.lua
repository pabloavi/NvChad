vim.g.tex_flavor = "latex"

vim.opt_local.spelllang = "es"
vim.opt_local.conceallevel = 0
vim.opt_local.spell = true

require("core.utils").load_mappings "latex"
vim.cmd "C"

-- vim.keymap.set("n", "<C-b>", vim.cmd.TexlabBuild, { desc = "Build LaTeX" })
-- vim.keymap.set("n", "<C-f>", vim.cmd.TexlabForward, { desc = "Forward Search" })
--
-- require("nvim-surround").buffer_setup {
--   surrounds = {
--     ['"'] = {
--       add = { "``", "''" },
--       find = "``.-''",
--       delete = "^(``)().-('')()$",
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
