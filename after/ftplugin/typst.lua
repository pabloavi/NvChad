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
