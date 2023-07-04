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
local n = extras.nonempty
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

snips = {
  s(
    { trig = "dv", name = "differential volume element", dscr = "differential volume element" },
    { t "\\diff V " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "dvp", name = "differential volume element prime", dscr = "differential volume element prime" },
    { t "\\diff V' " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "ds", name = "differential surface element", dscr = "differential surface element" },
    { t "\\diff S " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "dsp", name = "differential surface element prime", dscr = "differential surface element prime" },
    { t "\\diff S' " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "dl", name = "differential line element", dscr = "differential line element" },
    { t "\\diff \\vec{l} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "dlp", name = "differential line element prime", dscr = "differential line element prime" },
    { t "\\diff \\vec{l'} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "r([vsp])", name = "rho_vsp", dscr = "rho_vsp", regTrig = true },
    { t "\\rho_", f(function(_, snip)
      return snip.captures[1]
    end, {}), t " " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "E", name = "Electric field", dscr = "Electric field" },
    { t "\vec{E} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "B", name = "Magnetic field", dscr = "Magnetic field" },
    { t "\vec{B} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "H", name = "Magnetic field", dscr = "Magnetic field" },
    { t "\vec{H} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "J", name = "Current density", dscr = "Current density" },
    { t "\vec{J} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "D", name = "Electric displacement", dscr = "Electric displacement" },
    { t "\vec{D} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "P", name = "Magnetic polarization", dscr = "Magnetic polarization" },
    { t "\vec{P} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "faraday", name = "Faraday's law", dscr = "Faraday's law" },
    { t "\vec{E} = -\\frac{1}{c}\\frac{\\partial\\vec{B}}{\\partial t} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "ampere", name = "Ampere's law", dscr = "Ampere's law" },
    { t "\\vec{J} = \\mu_0\\vec{B} + \\mu_0\\epsilon_0\\frac{\\partial\\vec{E}}{\\partial t} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "int([vsc])", name = "EM.integralV", dscr = "EM. Integral de volumen V", regTrig = true },
    fmt(
      [[
      \int_<> <> \diff <> <>
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]:upper()
        end, {}),
        i(1),
        f(function(_, snip)
          return snip.captures[1]:upper()
        end, {}),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    {
      trig = "int([vsc])p",
      name = "EM.integralVSCp",
      dscr = "EM. Integral de volumen, superficie, contorno prima",
      regTrig = true,
    },
    fmt(
      [[
      \int_<> <> \diff <> <>
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]:upper() .. "'"
        end, {}),
        i(1),
        f(function(_, snip)
          return snip.captures[1]:upper() .. "'"
        end, {}),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

autosnips = {
  s(
    { trig = "\\mu 0", name = "auto 0 in mu_0", dscr = "auto 0 in mu_0" },
    { t "\\mu_0 " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- 1 over 4 pi epsilon_0
  s(
    { trig = "1p4", name = "1/(4 pi eps_0)", dscr = "1/(4 pi eps_0)" },
    { t "\\frac{1}{4 \\pi \\epsilon_0} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "([xyzrpt])u", name = "unitary vector", dscr = "unitary vector", regTrig = true },
    { t "\\vec{\\hat{", f(function(_, snip)
      return snip.captures[1]
    end, {}), t "}} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "rcu", name = "unitary vector", dscr = "unitary vector" },
    { t "\\vec{\\hat{r_c}} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

if enabled then
  return snips, autosnips
end

return nil, nil
