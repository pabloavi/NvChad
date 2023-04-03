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
    { trig = "it", name = "italic", dscr = "Insert italic text." },
    { t "\\textit{", i(1), t "}" },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "bf", name = "bold", dscr = "Insert bold text." },
    { t "\\textbf{", i(1), t "}" },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "em", name = "emphasize", dscr = "Insert emphasize text." },
    { t "\\emph{", i(1), t "}" },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "ttt", name = "ttt", dscr = "Insert ttt text." },
    { t "\\texttt{", i(1), t "}" },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "noin", name = "noindent", dscr = "\noindent in line begin" },
    { t "\\noindent" },
    { condition = tex.in_text * expand.line_begin }
  ),

  s(
    {
      trig = " cref",
      name = "cref",
      dscr = "Reference a figure, a table or an equation in text with cref",
      wordTrig = false,
    },
    { t "~\\cref{", c(1, { i(1, "eq"), i(1, "fig"), i(1, "tab") }), t ":", i(2), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    {
      trig = "cref",
      name = "cref",
      dscr = "Reference a figure, a table or an equation in text with cref",
      wordTrig = false,
    },
    { t "\\cref{", c(1, { i(1, "eq"), i(1, "fig"), i(1, "tab") }), t ":", i(2), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = " eqr", name = "equation reference", dscr = "Reference equation in text with eqref", wordTrig = false },
    { t "~\\eqref{eq:", i(1), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "eqr", name = "equation reference", dscr = "Reference equation in text with eqref", wordTrig = false },
    { t "\\eqref{eq:", i(1), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = " ref", name = "reference", dscr = "Reference a figure or a table in text with ref", wordTrig = false },
    { t "~\\ref{", c(1, { i(1, "fig"), i(1, "tab"), i(1, "sec") }), t ":", i(2), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "ref", name = "reference", dscr = "Reference a figure or a table in text with ref", wordTrig = false },
    { t "\\ref{", c(1, { i(1, "fig"), i(1, "tab"), i(1, "sec") }), t ":", i(2), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = " cite", name = "cite snippet", dscr = "cite snippet", wordTrig = false },
    { t "~\\cite{", i(1), t "} ", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "cite", name = "cite snippet", dscr = "cite snippet", wordTrig = false },
    { t "\\cite{", i(1), t "} ", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "eq-1", name = "Equation counter -1", dscr = "Set equation counter to current value - 1" },
    { t "\\setcounter{equation}{\\theequation-1}", i(0) },
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    { trig = "lbl", name = "label", dscr = "Insert label" },
    { t "\\label{", c(1, { i(1, "eq"), i(1, "fig"), i(1, "tab"), i(1, "sec") }), t ":", i(2), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
}

autosnips = {}

return snips, autosnips
