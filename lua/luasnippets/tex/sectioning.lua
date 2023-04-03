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
    { trig = "sec", name = "section", dscr = "Insert new section" },
    fmt(
      [[ 
      \section{<>}

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "secp", name = "section*", dscr = "Insert new section*" },
    fmt(
      [[ 
      \section*{<>}

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "ssec", name = "subsection", dscr = "Insert new subsection" },
    fmt(
      [[ 
      \subsection{<>}

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "ssecp", name = "subsection*", dscr = "Insert new subsection*" },
    fmt(
      [[ 
      \subsection*{<>}

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "sssec", name = "subsubsection", dscr = "Insert new subsection" },
    fmt(
      [[ 
      \subsubsection{<>}

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "sssecp", name = "subsubsection*", dscr = "Insert new subsubsection*" },
    fmt(
      [[ 
      \subsubsection*{<>}

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
}

autosnips = {
  s(
    { trig = "input", name = "input", dscr = "Insert input" },
    fmt(
      [[ 
      \input{<>}
      ]],
      { i(1) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "include", name = "include", dscr = "Insert include" },
    fmt(
      [[ 
      \include{<>}
      ]],
      { i(1) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
}

return snips, autosnips
