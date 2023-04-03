local snips, autosnips = {}, {}

local tex = vim.g.use_treesitter and require "luasnippets.tex.utils.ts_utils" or require "luasnippets.utils.tex.utils"

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

autosnips = {
  s(
    { trig = "->", name = "to", dscr = "to" },
    { t "\\to " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "to", name = "to", dscr = "to" },
    { t "\\to " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "=>", name = "implies", dscr = "Implies" },
    { t "\\implies " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "impl", name = "implies", dscr = "Implies" },
    { t "\\implies " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "=<", name = "implied by", dscr = "Implied by" },
    { t "\\impliedby " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "impb", name = "implied by", dscr = "implied by" },
    { t "\\impliedby " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "<=", name = "leq", dscr = "Less than or equal to" },
    { t "\\leq " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "le", name = "less than or equal to", dscr = "less than or equal to" },
    { t "\\leq " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = ">=", name = "geq", dscr = "Greater than or equal to" },
    { t "\\geq " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "ge", name = "greater than or equal to", dscr = "greater than or equal to" },
    { t "\\geq " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "<<", name = "much less than", dscr = "Much less than" },
    { t "\\ll " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "ll", name = "much less than", dscr = "much less than" },
    { t "\\ll " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = ">>", name = "much greater than", dscr = "Much greater than" },
    { t "\\gg " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "gg", name = "much greater than", dscr = "much greater than" },
    { t "\\gg " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "/=", name = "neq", dscr = "Not equal" },
    { t "\\neq " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "ne", name = "not equal", dscr = "not equal" },
    { t "\\neq " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "~", name = "similar to", dscr = "Similar to" },
    { t "\\sim " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "sim", name = "similar to", dscr = "similar to" },
    { t "\\sim " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "+-", name = "pm", dscr = "Plus minus" },
    { t "\\pm " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "pm", name = "plus minus", dscr = "plus minus" },
    { t "\\pm " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "lt", name = "<", dscr = "Less than" },
    { t "< " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "gt", name = ">", dscr = "Greater than" },
    { t "> " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- end binary operators

  s(
    { trig = "app", name = "approx", dscr = "Approximates" },
    { t "\\approx " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "eqv", name = "equiv", dscr = "Equivalent" },
    { t "\\equiv " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

return snips, autosnips
