local enabled = true
local snips, autosnips = {}, {}

local typst = require "luasnippets.typst.utils"

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

local functions = {
  { "abs", "abs" },
  { "norm", "norm" },
  -- { "conj", "Set" },

  { "dd", "dd" },
  { "var", "var" },
  { "prom", "expval" },

  { "bra", "bra" },
  { "ket", "ket" },
  { "brk", "braket" },
  { "kbr", "ketbra" },

  { "diag", "diag" },
}

local text_snippets = {
  { "hb", "hbar", "planck constant hbar" },
  { "eps", "epsilon", "epsilon" },
  { "cd", "dprod", "dot product, producto escalar, punto" },
  { "xx", "cprod", "cross product, producto vectorial" },
}

snips = {}

autosnips = {
  s(
    { trig = "tra", name = "traspuesta", dscr = "traspuesta", wordTrig = false },
    { t "^TT " },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),

  s(
    { trig = "DD", name = "derivative", dscr = "derivative" },
    { t "dv(", i(1), t ",", i(2), t ")" },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),

  s(
    { trig = "PP", name = "partial derivative", dscr = "partial derivative" },
    { t "pdv(", i(1), t ",", i(2), t ")" },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),

  -- postfix
  postfix("bar", { l("bar(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix("gor", { l("hat(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix("cal", { l("cal(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  -- postfix("til", { l("\\widetilde{" .. l.POSTFIX_MATCH .. "} ") }, { condition = typst.in_mathzone }),
  postfix("ve", { l("va(" .. l.POSTFIX_MATCH .. ") ") }, { condition = typst.in_mathzone }),
  postfix(",.", { l("va(" .. l.POSTFIX_MATCH .. ") ") }, { condition = typst.in_mathzone }),
  postfix(".,", { l("va(" .. l.POSTFIX_MATCH .. ") ") }, { condition = typst.in_mathzone }),
}

for _, func in ipairs(functions) do
  local trig, name = func[1], func[2]
  table.insert(
    autosnips,
    s({ trig = trig, name = name, dscr = name }, { t(name), t "(", i(1), t ") " }, { condition = typst.in_mathzone })
  )
end

for _, func in ipairs(text_snippets) do
  local trig, name, dscr = func[1], func[2], func[3]
  table.insert(
    autosnips,
    s({ trig = trig, name = name, dscr = dscr }, { t(name), t " " }, { condition = typst.in_mathzone })
  )
end

if enabled then
  return snips, autosnips
end

return nil, nil
