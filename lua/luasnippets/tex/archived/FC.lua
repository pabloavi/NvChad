local enabled = false

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

snips = {
  s(
    { trig = "newop", name = "Declare new operator", dscr = "Declare new operator" },
    { t "\\DeclareMathOperator{\\", i(1), t "}{", i(2), t "}" }
  ),
  s(
    { trig = "newcmd", name = "Declare new command", dscr = "Declare new command" },
    { t "\\newcommand{\\", i(1), t "}{", i(2), t "}" }
  ),

  -- setup braket notation
  s(
    { trig = "setupbraket", name = "setup bracket notation", dscr = "setup bracket notation" },
    fmt(
      [[
      \newcommand{\braket}[2]{\left\langle #1 \middle| #2 \right\rangle}
      \newcommand{\bra}[1]{\left\langle #1 \middle|}
      \newcommand{\ket}[1]{\middle| #1 \right\rangle}
      <>
      ]],
      { i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),

  s(
    { trig = "setupop", name = "Setup operator command", dscr = "Setup operator command" },
    fmt(
      [[
    \newcommand{\op}[1]{\hat{\mathcal{#1}}}
    <>
    ]],
      { i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),

  s({ trig = "op", name = "Operator", dscr = "Operator" }, { t "\\op{", i(1), t "}" }),
}

autosnips = {
  s(
    { trig = "E([nm])", name = "E_n, E_m", dscr = "E_n, E_m", regTrig = true },
    { t "E_", f(function(_, snip)
      return snip.captures[1]
    end), t " " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- "E_n number" -> "E_n^{(number)}"
  s({ trig = "E_([nm]) ([0-9]+)", name = "E_n^{(number)}", dscr = "E_n^{(number)}", regTrig = true }, {
    t "E_",
    f(function(_, snip)
      return snip.captures[1]
    end),
    t "^{(",
    f(function(_, snip)
      return snip.captures[2]
    end),
    t ")} ",
  }, { condition = tex.in_mathzone, show_condition = tex.in_mathzone }),

  s(
    { trig = "psi ([nm])", name = "psi sub n,m", dscr = "psi sub n,m", regTrig = true },
    { t "psi_", f(function(_, snip)
      return snip.captures[1]
    end), t " " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s({ trig = "psi_([nm]) ([0-9]+)", name = "psi_n^{(number)}", dscr = "psi_n^{(number)}", regTrig = true }, {
    t "psi_",
    f(function(_, snip)
      return snip.captures[1]
    end),
    t "^{(",
    f(function(_, snip)
      return snip.captures[2]
    end),
    t ")} ",
  }, { condition = tex.in_mathzone, show_condition = tex.in_mathzone }),

  s(
    { trig = "phi ([nm])", name = "phi sub n,m", dscr = "phi sub n,m", regTrig = true },
    { t "phi_", f(function(_, snip)
      return snip.captures[1]
    end), t " " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s({ trig = "phi_([nm]) ([0-9]+)", name = "phi_n^{(number)}", dscr = "phi_n^{(number)}", regTrig = true }, {
    t "phi_",
    f(function(_, snip)
      return snip.captures[1]
    end),
    t "^{(",
    f(function(_, snip)
      return snip.captures[2]
    end),
    t ")} ",
  }, { condition = tex.in_mathzone, show_condition = tex.in_mathzone }),

  -- s(
  --   { trig = "bra", name = "bra dirac notation", dscr = "bra dirac notation" },
  --   { t "\\bra{", i(1), t "} " },
  --   { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  -- ),
  -- s(
  --   { trig = "ket", name = "ket dirac notation", dscr = "ket dirac notation" },
  --   { t "\\ket{", i(1), t "} " },
  --   { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  -- ),
  s(
    { trig = "bk", name = "bra-ket dirac notation", dscr = "bra-ket dirac notation" },
    { t "\\braket{", i(1), t "}{", i(2), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "br", name = "bra dirac notation", dscr = "bra dirac notation" },
    { t "\\bra{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "kt", name = "ket dirac notation", dscr = "ket dirac notation" },
    { t "\\ket{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  postfix("bra", { l("\\bra{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("ket", { l("\\ket{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("op", { l("\\op{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
}

if enabled then
  return snips, autosnips
end

return nil, nil
