local enabled = false
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
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

snips = {
  s(
    { trig = "sij", name = "fluidos.sigma_ij", dscr = "fluidos.sigma_ij" },
    { t "\\sigma_ij ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "nube", name = "atm.cloud", dscr = "atm.cloud" },
    fmt(
      [[
      \cloud{<>}{<>}{<>}{<>} <>
      ]],
      {
        i(1, "number"),
        i(2, "side"),
        i(3, "width"),
        i(4, "texto"),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "nubep", name = "atm.cloudp", dscr = "atm.cloudp" },
    fmt(
      [[
      \cloud[<>]{<>}{<>}{<>}{<>} <>
      ]],
      {
        i(1, "caption"),
        i(2, "number"),
        i(3, "side"),
        i(4, "width"),
        i(5, "texto"),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
}

autosnips = {
  s(
    { trig = "([vnrUV])([ipkxyz])", name = "fluidos.r,v,nabla", dscr = "fluidos.r,v,nabla", regTrig = true },
    fmt(
      [[
    <>_<> <>
    ]],
      {
        f(function(_, snip)
          if snip.captures[1] == "n" then
            snip.captures[1] = "\\nabla"
          end
          return snip.captures[1]
        end),
        f(function(_, snip)
          if snip.captures[2] == "p" then
            snip.captures[2] = "j"
          end
          return snip.captures[2]
        end),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- vpi vpj vpz vpx vpy is v'i, v'j, v'z, v'x, v'y
  s(
    { trig = "(vp([ipkxyz])'", name = "fluidos.v'", dscr = "fluidos.v'", regTrig = true },
    fmt(
      [[
      v'_<> <>
      ]],
      {
        f(function(_, snip)
          if snip.captures[1] == "p" then
            snip.captures[1] = "j"
          end
          return snip.captures[1]
        end),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "sijp", name = "fluidos.sigma_ij'", dscr = "fluidos.sigma_ij'" },
    { t "\\sigma'_{ij} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- NOTE: revise
  s(
    { trig = "boltz", name = "fluidos.boltzmann", dscr = "fluidos.boltzmann" },
    { t "\\frac{1}{2} \\left( \\frac{m}{\\pi k_B T} \\right)^{3/2} e^{-\\frac{m}{2k_B T} v^2} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- NOTE: revise
  s(
    { trig = "fle", name = "fluidos.f_LE", dscr = "fluidos.f_LE" },
    { t "f_{LE} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "prom", name = "fluidos.promedio", dscr = "fluidos.promedio" },
    { t "\\langle ", i(1), t " \\rangle ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "vmed", name = "fluidos.valormedio", dscr = "fluidos.valormedio" },
    { t "\\overline{", i(1), t "} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- NOTE: revise
  s(
    { trig = "indv", name = "fluidos.intv", dscr = "fluidos.intv" },
    { t "\\int_{-\\infty}^{\\infty} \\diff \\vec{v}\\, ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- f(r,v,t) with r and v vectors and choice nodes for r and v as r' and v'
  s(
    { trig = "frvt", name = "fluidos.f(r,v,t)", dscr = "fluidos.f(r,v,t)" },
    fmt(
      [[
      f(<>) <>
      ]],
      {
        c(1, { t "\\vec{r}, \\vec{v}, t", t "\\vec{r}', \\vec{v}', t" }),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- fluidos fstr \\fstr
  s(
    { trig = "fst", name = "fluidos.fstr", dscr = "fluidos.fstr" },
    { t "\\fstr ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- fluidos fcol \\fcol
  s(
    { trig = "fco", name = "fluidos.fcol", dscr = "fluidos.fcol" },
    { t "\\fcol ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- divergencia y rotacional requieren el paquete 'physics'
  s(
    { trig = "div", name = "divergencia", dscr = "divergencia" },
    { t "\\div{", i(1), t "}", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "rot", name = "rotacional", dscr = "rotacional" },
    { t "\\rot{", i(1), t "}", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- ATMOSFERAS
  s(
    { trig = "sbd", name = "atm.SBDART", dscr = "atm.SBDART in verbatim" },
    { t "\\verb_SBDART_ ", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "verb", name = "verbose", dscr = "verbose input" },
    { t "\\verb_", i(1), t "_ ", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "par", name = "formulario.nuevaformula", dscr = "formulario.Añadir nuevo párrafo + fórmula" },
    fmt(
      [[
      \paragraph{\textbf{<>}.} <>
      ]],
      {
        i(1),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  -- \siguiente, sig, texintext
  -- s(
  --   { trig = "sig", name = "formulario.siguiente", dscr = "formulario.siguiente" },
  --   { t "{\\siguiente} ", i(0) },
  --   { condition = tex.in_text, show_condition = tex.in_text }
  -- ),

  -- electromagnetism II, EM
  s(
    { trig = "Fi", name = "electromagnetismo.tensor", dscr = "electromagnetismo.tensor" },
    { t "\\tensor{F}{^i^j} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "fi", name = "electromagnetismo.tensor", dscr = "electromagnetismo.tensor" },
    { t "\\tensor{F}{_i_j} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

if enabled then
  return snips, autosnips
end

return nil, nil
