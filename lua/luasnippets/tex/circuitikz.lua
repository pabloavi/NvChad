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

local snips = {}

local autosnips = {
  s(
    { trig = "sh", name = "short circuitikz", dscr = "short circuitikz" },
    { t "[short,", i(1), t "] ", i(0) },
    { condition = tex.in_circuitikz, show_condition = tex.in_circuitikz }
  ),
  s(
    { trig = "no", name = "node circuitikz", dscr = "node circuitikz" },
    { t "node [", i(1, "type"), t "] at ", t "(", i(2), t ") ", t "{", i(3, "text"), t "}", i(0) },
    { condition = tex.in_circuitikz * expand.line_begin, show_condition = tex.in_circuitikz }
  ),

  s(
    { trig = "vno", name = "voltage node", dscr = "voltage node" },
    fmt(
      [[
    node [<>] at (<>) {\( <> \)} (<>) to [short,*-] (<>)
    ]],
      { i(1, "position"), i(2), i(3, "label"), rep(2), rep(2) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin * tex.in_circuitikz, show_condition = tex.in_circuitikz }
  ),

  s(
    { trig = "inv", name = "invert circuitikz", dscr = "invert circuitikz" },
    { t "invert", i(0) },
    { condition = tex.in_circuitikz_node, show_condition = tex.in_circuitikz_node }
  ),
  s(
    { trig = "bat1", name = "battery1 circuitikz", dscr = "battery1 circuitikz" },
    { t "battery1", i(0) },
    { condition = tex.in_circuitikz_node, show_condition = tex.in_circuitikz_node }
  ),

  s(
    { trig = "gr", name = "circuitikz ground", dscr = "circuitikz ground" },
    { t "ground", i(0) },
    { condition = tex.in_circuitikz_node, show_condition = tex.in_circuitikz_node }
  ),
  -- above, below, left, right in node
  s(
    { trig = "ab", name = "above circuitikz", dscr = "above circuitikz" },
    { t "above", i(0) },
    { condition = tex.in_circuitikz_node, show_condition = tex.in_circuitikz_node }
  ),
  s(
    { trig = "be", name = "below circuitikz", dscr = "below circuitikz" },
    { t "below", i(0) },
    { condition = tex.in_circuitikz_node, show_condition = tex.in_circuitikz_node }
  ),
  s(
    { trig = "le", name = "left circuitikz", dscr = "left circuitikz" },
    { t "left", i(0) },
    { condition = tex.in_circuitikz_node, show_condition = tex.in_circuitikz_node }
  ),
  s(
    { trig = "ri", name = "right circuitikz", dscr = "right circuitikz" },
    { t "right", i(0) },
    { condition = tex.in_circuitikz_node, show_condition = tex.in_circuitikz_node }
  ),

  s(
    { trig = "ar", name = "arrow circuitikz", dscr = "arrow circuitikz" },
    { t "\\draw[-latex] (", i(1), t ") -- (", i(2), t ");", i(0) },
    { condition = tex.in_circuitikz * expand.line_begin, show_condition = tex.in_circuitikz }
  ),

  s(
    { trig = "mesh", name = "mesh circuitikz", dscr = "mesh circuitikz" },
    { t "\\draw[thin, <-, >=triangle 45] (", i(1), t ") node{$", i(2), t "$}  ++(-60:0.5) arc (-60:170:0.5);", i(0) },
    { condition = tex.in_circuitikz * expand.line_begin, show_condition = tex.in_circuitikz }
  ),
}

if enabled then
  return snips, autosnips
end

return nil, nil
