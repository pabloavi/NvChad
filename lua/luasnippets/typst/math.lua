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

local function_snippets = { -- shorter, add pars, args
  { "abs", "abs" },
  { "norm", "norm" },
  { "set", "Set" },

  { "dd", "dd" },
  { "var", "var" },
  { "prom", "expval" },

  { "DD", "dv", 2 },
  { "PP", "pdv", 2 },

  { "bra", "bra" },
  { "ket", "ket" },
  { "brk", "braket" },
  { "kbr", "ketbra" },

  { "diag", "diag" },
}

local text_snippets = { -- shorter and adds a space
  { "hb", "hbar", "planck constant hbar" },
  { "eps", "epsilon", "epsilon" },

  { "cd", "dprod", "dot product, producto escalar, punto" },
  { "xx", "cprod", "cross product, producto vectorial" },

  { "int", "integral", "integral" },

  { "fa", "forall", "for all" },

  { "ne", "eq.not", "not equal" },
}

local word_text_snippets = {
  { "tra", "^TT ", "traspuesta" },

  { "sr", "^2", "fast squared" },
  { "cr", "^3", "fast cubed" },
}

snips = {}

autosnips = {

  s(
    { trig = "fr", name = "fraction", dscr = "fraction" },
    { t "(", i(1), t ") / (", i(2), t ") " },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
  ),

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
      return string.format("%s_{%s} ", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }, { condition = typst.in_mathzone }),

  -- postfix
  postfix("bar", { l("bar(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix("gor", { l("hat(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  postfix("cal", { l("cal(" .. l.POSTFIX_MATCH .. ")") }, { condition = typst.in_mathzone }),
  -- postfix("til", { l("\\widetilde{" .. l.POSTFIX_MATCH .. "} ") }, { condition = typst.in_mathzone }),
  postfix("uni", { l("vu(" .. l.POSTFIX_MATCH .. ") ") }, { condition = typst.in_mathzone }),
  postfix("ve", { l("va(" .. l.POSTFIX_MATCH .. ") ") }, { condition = typst.in_mathzone }),
  postfix(",.", { l("va(" .. l.POSTFIX_MATCH .. ") ") }, { condition = typst.in_mathzone }),
  postfix(".,", { l("va(" .. l.POSTFIX_MATCH .. ") ") }, { condition = typst.in_mathzone }),
}

for _, func in ipairs(text_snippets) do
  local trig, name, dscr = func[1], func[2], func[3]
  table.insert(
    autosnips,
    s({ trig = trig, name = name, dscr = dscr }, { t(name), t " " }, { condition = typst.in_mathzone })
  )
end

for _, func in ipairs(word_text_snippets) do
  local trig, name, dscr = func[1], func[2], func[3]
  table.insert(
    autosnips,
    s(
      { trig = trig, name = name, dscr = dscr, wordTrig = false },
      { t(name), t " " },
      { condition = typst.in_mathzone }
    )
  )
end

for _, func in ipairs(function_snippets) do
  local trig, name = func[1], func[2]
  local nodes_table = { t(name), t "(", i(1) }
  local number = func[3] or 1
  for k = 1, number - 1 do
    table.insert(nodes_table, t ",")
    table.insert(nodes_table, i(k + 1))
  end
  table.insert(nodes_table, t ") ")
  table.insert(autosnips, s({ trig = trig, name = name, dscr = name }, nodes_table, { condition = typst.in_mathzone }))
end

if enabled then
  return snips, autosnips
end

return nil, nil
