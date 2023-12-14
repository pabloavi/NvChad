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

snips = {
  s(
    { trig = "lr", name = "left/right()", dscr = "left/right()" },
    fmt(
      [[
        {\left( <> \right)} <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "lrc", name = "left/right[]", dscr = "left/right[]" },
    fmt(
      [[
        {\left[ <> \right]} <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "lrm", name = "left/right||", dscr = "left/right||" },
    fmt(
      [[
        {\left| <> \right|} <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "lra", name = "left/right<>", dscr = "left/right<>" },
    fmt(
      [[
        {\left< [] \right>} [] 
      ]],
      { i(1), i(0) },
      { delimiters = "[]" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "lrb", name = "left\\{/right\\}", dscr = "left/right\\{}" },
    fmt(
      [[
        {\left\{ <> \right\}} <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- langle and rangle
  s(
    { trig = "prom", name = "langle/rangle", dscr = "langle/rangle" },
    fmt(
      [[
        {\langle <> \rangle} <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- lvert and rvert
  s(
    { trig = "lrv", name = "lvert/rvert", dscr = "lvert/rvert" },
    fmt(
      [[
        {\lvert <> \rvert} <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

return snips, autosnips
