local enabled = true
local snips, autosnips = {}, {}

local tex = vim.g.use_treesitter and require "luasnippets.tex.utils.ts_utils" or require "luasnippets.tex.utils.utils"

local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt
local expand = require "luasnip.extras.conditions.expand"
local extras = require "luasnip.extras"
local m = extras.m
local n = extras.nonempty
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

snips = {}

-- stadistics physics snippets
autosnips = {
  s(
    { trig = "indx", name = "estadistica.intv", dscr = "estadistica.intv" },
    { t "\\int_{", i(1, "-\\infty"), t "}^{", i(2, "\\infty"), t "} \\diff x\\, ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

if enabled then
  return snips, autosnips
end

return nil, nil
