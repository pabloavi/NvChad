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

local base_units = {
  -- { "ampere", "amperio", "A" },
  -- { "candela", "candela", "cd" },
  -- { "kelvin", "kelvin", "K" },
  -- { "kilogram", "kilogramo", "kg" },
  -- { "meter", "metro", "mm" }, -- to avoid conflict with mol
  -- { "mole", "mol", "mol" },
  -- { "second", "segundo", "ss" }, -- to avoid conflict with sr
}

local derived_units = {
  -- { "becquerel", "bequerelio", "bq" },
  { "degreeCelsius", "celsius", "gC" },
  -- { "coulomb", "culombio", "C" },
  -- { "decibel", "decibelio", "dB" },
  { "degree", "grado", "gr" }, -- to avoid conflict with Coulomb
  -- { "farad", "faradio", "F" },
  -- { "hertz", "hercio", "Hz" },
  -- { "henry", "henrios", "He" }, -- to avoid conflict with hertz
  -- { "joule", "julio", "J" },
  -- { "newton", "newton", "N" },
  { "ohm", "ohm", "o" },
  -- { "pascal", "pascal", "Pa" },
  -- { "radian", "radian", "rad" },
  -- { "siemens", "siemen", "S" },
  -- { "steradian", "steoradian", "sr" },
  -- { "tesla", "tesla", "T" },
  -- { "volt", "voltio", "V" },
  -- { "watt", "wattio", "W" },
  -- { "weber", "weber", "wb" }, -- to avoid conflict with watt
}

local prefixes = {
  -- { "atto", "atto" },
  -- { "centi", "centi" },
  -- { "deci", "deci" },
  -- { "deca", "deca" },
  -- { "exa", "exa" },
  -- { "femto", "femto" },
  -- { "giga", "giga" },
  -- { "hecto", "hecto" },
  -- { "kilo", "kilo" },
  -- { "mega", "mega" },
  { "micro", "micro" },
  -- { "milli", "mili" },
  -- { "nano", "nano" },
  -- { "peta", "peta" },
  -- { "pico", "pico" },
  -- { "tera", "tera" },
  -- { "yocto", "yocto" },
  -- { "yotta", "yotta" },
  -- { "zepto", "zepto" },
  -- { "zetta", "zetta" },
  -- { "nkilo", "nk" },
}

local conditions = {
  tex.in_SI,
  tex.in_si,
}

for _, condition in ipairs(conditions) do
  -- for each element in base_units, create two snippets: 1 is the result of triggers 2 and 3
  -- example: amperio --> \ampere, A --> \ampere
  for _, unit in ipairs(base_units) do
    local siunit = unit[1]
    local spanish = unit[2]
    local symbol = unit[3]
    local snippet = s(symbol, {
      t("\\" .. siunit .. " "),
      i(0),
    }, { condition = condition })
    table.insert(autosnips, snippet)
    local snippet = s(spanish, {
      t("\\" .. siunit .. " "),
      i(0),
    }, { condition = condition })
    table.insert(autosnips, snippet)
  end

  -- same for derived_units
  for _, unit in ipairs(derived_units) do
    local siunit = unit[1]
    local spanish = unit[2]
    local symbol = unit[3]
    local snippet = s(symbol, {
      t("\\" .. siunit .. " "),
      i(0),
    }, { condition = condition })
    table.insert(autosnips, snippet)
    local snippet = s(spanish, {
      t("\\" .. siunit .. " "),
      i(0),
    }, { condition = condition })
    table.insert(autosnips, snippet)
  end

  -- for prefixes, 1 is result, trigger is 2
  for _, prefix in ipairs(prefixes) do
    local siunit = prefix[1]
    local spanish = prefix[2]
    local snippet = s(spanish, {
      t("\\" .. siunit .. " "),
      i(0),
    }, { condition = condition })
    table.insert(autosnips, snippet)
  end
end

-- num with trigger \nu m (for \nu)
local snippet = s("\\nu m", {
  t "\\num{",
  i(1),
  t "} ",
  i(0),
}, { condition = tex.in_mathzone })
table.insert(autosnips, snippet)

local more_snippets = {
  s(
    { trig = "SI", name = "SI units", dscr = "Insert SI units in text" },
    { t "\\SI{", i(1), t "}{", i(2), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "ran", name = "SI range", dscr = "Insert SI range in text (inserts inline math mode)" },
    { t "\\SIrange{", i(1), t "}{", i(2), t "}", t "{", i(3), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "si", name = "unit", dscr = "Insert unit in text" },
    { t "\\si{", i(1), t "}", i(0) },
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
}

local more_auto_snippets = {
  -- s(
  --   { trig = "SI", name = "SI units", dscr = "Insert SI units in math mode" },
  --   { t "\\SI{", i(1), t "}{", i(2), t "}", i(0) },
  --   { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  -- ),
  s(
    { trig = "ran", name = "SI range", dscr = "Insert SI range in math mode" },
    { t "\\SIrange{", i(1), t "}{", i(2), t "}", t "{", i(3), t "}", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "si", name = "unit", dscr = "Insert unit in math mode" },
    { t "\\si{", i(1), t "}", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

for _, snippet in ipairs(more_snippets) do
  table.insert(snips, snippet)
end

vim.tbl_extend("force", autosnips, more_auto_snippets)

if enabled then
  return snips, autosnips
end

return nil, nil
