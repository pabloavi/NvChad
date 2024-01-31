local enabled = true
local snips, autosnips = {}, {}

local typst = require "luasnippets.typst.ts_utils"

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

local function_snippets = { -- shorter, add pars, args
  { trig = "abs", text = "abs", pars = 1 },
  { trig = "norm", text = "norm", pars = 1 },
  { trig = "set", text = "Set", pars = 1 },
  { trig = "grad", text = "grad", pars = 1 },
  { trig = "div", text = "div", pars = 1 },
  { trig = "rot", text = "curl", pars = 1 },
  { trig = "lap", text = "laplacian", pars = 1 },

  { trig = "dd", text = "dd", pars = 1 },
  { trig = "var", text = "var", pars = 1 },
  { trig = "prom", text = "expval", pars = 1 },

  { trig = "sqrt", text = "sqrt", pars = 1 },
  { trig = "ln", text = "ln", pars = 1 },

  { trig = "DD", text = "dv", pars = 2 },
  { trig = "PP", text = "pdv", pars = 2 },

  { trig = "bra", text = "bra", pars = 1 },
  { trig = "ket", text = "ket", pars = 1 },
  { trig = "brk", text = "braket", pars = 1 },
  { trig = "kbr", text = "ketbra", pars = 1 },

  { trig = "diag", text = "diag", pars = 1 },

  { trig = "ss", text = "_", pars = 1, word = false },

  -- text ones
  { trig = "hb", text = "hbar", dscr = "planck constant hbar" },
  { trig = "kb", text = "k_B", dscr = "boltzmann constant" },

  { trig = "eps", text = "epsilon", dscr = "epsilon" },
  { trig = "ps", text = "psi", dscr = "psi" },
  { trig = "ph", text = "phi", dscr = "phi" },
  { trig = "the", text = "theta", dscr = "theta" },

  { trig = "cd", text = "dprod", dscr = "dot product, producto escalar, punto" },
  { trig = "xx", text = "cprod", dscr = "cross product, producto vectorial" },

  { trig = "inf", text = "infinity", dscr = "infinity" },

  { trig = "fa", text = "forall", dscr = "for all" },
  { trig = "ne", text = "eq.not", dscr = "not equal" },

  -- word text
  { trig = "tra", text = "^TT ", dscr = "traspuesta", word = false },
  { trig = "sr", text = "^2", dscr = "fast squared", word = false },
  { trig = "cr", text = "^3", dscr = "fast cubed", word = false },
  { trig = "ala", text = "^", dscr = "fast cubed", pars = 1, word = false },
  { trig = "con", text = "^*", dscr = "conjugado", word = false },
}

snips = {}

autosnips = {
  s(
    { trig = "fr", name = "fraction", dscr = "fraction" },
    { t "(", i(1), t ") / (", i(2), t ") " },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),

  -- start siunitx
  s(
    { trig = "qty", name = "siunitx SI qty", dscr = "siunitx SI qty" },
    { t "qty(", i(1), t ',"', i(2), t '")' },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),
  -- s(
  --   { trig = "si", name = "siunitx si unit", dscr = "siunitx si unit" },
  --   { t 'unit("', i(1), t '")' },
  --   { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  -- ),
  s(
    { trig = "num", name = "siunitx num", dscr = "siunitx num" },
    { t "num(", i(1), t ")" },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),

  s(
    { trig = "int", name = "integral with choice", dscr = "integral with choice" },
    fmt(
      [[
    integral<>
    ]],
      {
        c(1, {
          { t " ", i(1) },
          sn(nil, { t "_(", i(1), t ")^(", i(2), t ")", i(3) }),
        }),
      },
      { delimiters = "<>" }
    ),
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),
  -- end siunitx

  s({
    trig = "([%a])(%d)",
    name = "auto subscript",
    regTrig = true,
    wordTrig = false,
  }, {
    f(function(_, snip)
      return string.format("%s_%s", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }, { condition = typst.in_mathzone }),

  s({
    trig = "([%a])_(%d%d)",
    name = "auto subscript 2",
    regTrig = true,
  }, {
    f(function(_, snip)
      return string.format("%s_%s", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }, { condition = typst.in_mathzone }),

  -- postfix
  postfix("bar", { l("bar(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix("gor", { l("hat(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix("cal", { l("cal(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  -- postfix("til", { l("\\widetilde{" .. l.POSTFIX_MATCH .. "} ") }, { condition = typst.in_mathzone }),
  postfix("uni", { l("vu(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix("ve", { l("va(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix(",.", { l("va(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix(".,", { l("va(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
}

for _, snippet in ipairs(function_snippets) do
  local trig, text, dscr, pars = snippet["trig"], snippet["text"], snippet["dscr"], snippet["pars"]
  local word = true
  if snippet["word"] ~= nil then
    word = snippet["word"]
  end
  local nodes = { t(text) }
  if pars then
    nodes = { t(text), t "(", i(1) }
    for k = 1, pars - 1 do
      table.insert(nodes, t ",")
      table.insert(nodes, i(k + 1))
    end
    table.insert(nodes, t ")")
  end
  table.insert(
    autosnips,
    s({ trig = trig, name = text, dscr = dscr, wordTrig = word }, nodes, { condition = typst.in_mathzone })
  )
end

if enabled then
  return snips, autosnips
end

return nil, nil
