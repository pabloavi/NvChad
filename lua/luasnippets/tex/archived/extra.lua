local snips, autosnips = {}, {}

local tex = {}

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
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

tex.in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

tex.in_comment = function()
  return vim.fn["vimtex#syntax#in_comment"]() == 1
end

tex.in_text = function()
  return not tex.in_mathzone() and not tex.in_comment()
end

tex.in_align = function()
  return vim.fn["vimtex#env#is_inside"]("align")[1] ~= 0
end

tex.in_itemize = function()
  return vim.fn["vimtex#env#is_inside"]("itemize")[1] ~= 0
end

tex.not_in_itemize = function()
  return not (vim.fn["vimtex#env#is_inside"]("itemize")[1] ~= 0)
end

tex.in_enumerate = function()
  return vim.fn["vimtex#env#is_inside"]("enumerate")[1] ~= 0
end

tex.not_in_enumerate = function()
  return not (vim.fn["vimtex#env#is_inside"]("enumerate")[1] ~= 0)
end

disabled_snips = {
  ls.parser.parse_snippet({ trig = "sum", name = "sum" }, "\\sum_{n=${1:1}}^{${2:\\infty}} ${3:a_n z^n}"),

  ls.parser.parse_snippet(
    { trig = "taylor", name = "taylor" },
    "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"
  ),

  ls.parser.parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}}"),
  ls.parser.parse_snippet({ trig = "limsup", name = "limsup" }, "\\limsup_{${1:n} \\to ${2:\\infty}}"),

  ls.parser.parse_snippet(
    { trig = "prod", name = "product" },
    "\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:${TM_SELECTED_TEXT}} $0"
  ),

  ls.parser.parse_snippet({ trig = "part", name = "d/dx" }, "\\frac{\\partial ${1:V}}{\\partial ${2:x}} $0"),
  ls.parser.parse_snippet({ trig = "ddx", name = "d/dx" }, "\\frac{\\mathrm{d/${1:V}}}{\\mathrm{d${2:x}}} $0"),

  ls.parser.parse_snippet({ trig = "lr", name = "left( right)" }, "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"),
  ls.parser.parse_snippet({ trig = "(", name = "left( right)" }, "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"),
  ls.parser.parse_snippet({ trig = "lr|", name = "left| right|" }, "\\left\\| ${1:${TM_SELECTED_TEXT}} \\right\\| $0"),
  ls.parser.parse_snippet(
    { trig = "lr{", name = "left{ right}" },
    "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
  ),
  ls.parser.parse_snippet({ trig = "lr[", name = "left[ right]" }, "\\left[ ${1:${TM_SELECTED_TEXT}} \\right] $0"),
  ls.parser.parse_snippet(
    { trig = "lra", name = "leftangle rightangle" },
    "\\left< ${1:${TM_SELECTED_TEXT}} \\right>$0"
  ),

  ls.parser.parse_snippet(
    { trig = "lrb", name = "left\\{ right\\}" },
    "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
  ),

  ls.parser.parse_snippet(
    { trig = "sequence", name = "Sequence indexed by n, from m to infinity" },
    "(${1:a}_${2:n})_{${2:n}=${3:m}}^{${4:\\infty}}"
  ),
}

disabled_autosnips = {
  s(
    { trig = "beg", name = "begin/end", dscr = "Begin/End environment" },
    fmt(
      [[
  \begin{<>}
      <>
  \end{<>}
  <>
  ]],
      { i(1), i(2), rep(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),
  s(
    { trig = "case", name = "Cases environment", dscr = "Cases environment" },
    fmt(
      [[
      \begin{cases}
      <> ,\\
      <>
      \end{cases}
      <>
      ]],
      { i(1), i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin * tex.in_text, show_condition = expand.line_begin * tex.in_text }
  ),
}

return snips, autosnips
