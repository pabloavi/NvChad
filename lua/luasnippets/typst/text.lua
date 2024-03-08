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
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

local function neg(fn, ...)
  return not fn(...)
end

local function even_count(c)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, c, "")
  return ct % 2 == 0
end

table.unpack = table.unpack or unpack

local function part(func, ...)
  local args = { ... }
  return function()
    return func(table.unpack(args))
  end
end

local function char_count_same(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  if c1 == c2 then
    return ct1 % 2 == 0
  end
  return ct1 == ct2
end

local function pair(pair_begin, pair_end, expand_func, ...)
  return s({ trig = pair_begin, wordTrig = false }, { t { pair_begin }, i(1), t { pair_end } }, {
    condition = function()
      return not typst.in_import()
    end, -- part(expand_func, part(..., pair_begin, pair_end)),
    show_condition = function()
      return false
    end,
  })
end

local useful_envs = {
  "capci",
  "nota",
  "defi",
  "postu",
  "ejer",
  "ejem",
}

local function_snippets = {
  -- { trig = "si", text = "#unit", dscr = "SI unit", pars = 1 },
  -- { trig = "SI", text = "#qty", dscr = "SI quantity", pars = 2 },
  -- { trig = "num", text = "#num", dscr = "SI number", pars = 1 },
}

snips = {
  -- "preamble"
  s(
    { trig = "setupsen", name = "setup sen operators", dscr = "setup sen operators" },
    fmt(
      [[
    #let sen = math.op("sen")
    #let asen = math.op("asen")
    #let senh = math.op("senh")
    #let arcsen = math.op("arcsen")
    ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = typst.in_template, show_condition = typst.in_template }
  ),

  -- envs
  s(
    { trig = "img", name = "figure", dscr = "figure" },
    fmt(
      [[
      #figure(
        image("figures/{}", width: {}%),
        caption: [{}],
      ) <img:{}>

      {}
    ]],
      { i(1), i(2, "70"), i(3), i(4), i(0) },
      { delimiters = "{}" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),

  s(
    { trig = "tab", name = "table", dscr = "table" },
    fmt(
      [[
      #figure(
        table(
          {}
        ),
        caption: [{}],
      ) <tab:{}>

      {}
    ]],
      { i(1), i(2), i(3), i(0) },
      { delimiters = "{}" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),

  -- start siunitx
  s(
    { trig = "qty", name = "siunitx SI qty", dscr = "siunitx SI qty" },
    { t "#qty(", i(1), t ',"', i(2), t '")' },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),
  s(
    { trig = "si", name = "siunitx si unit", dscr = "siunitx si unit" },
    { t '#unit("', i(1), t '")' },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),
  s(
    { trig = "num", name = "siunitx num", dscr = "siunitx num" },
    { t "#num(", i(1), t ")" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),
  -- end siunitx

  s(
    { trig = "isot", name = "isotope", dscr = "isotope" },
    { t "#isotope(", i(1), t ")" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "co2", name = "CO2", dscr = "CO2" },
    { t '$"CO"_2$' },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "breaktab", name = "break table", dscr = "break table" },
    { t "#show figure: set block(breakable: true)" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),
}

autosnips = {
  pair("$", "$", neg, char_count_same),

  s(
    { trig = "@", name = "@ reference or citation", dscr = "@ reference or citation" },
    { t "@", c(1, { i(1, "img"), i(1, "tab"), i(1, "eq") }), t ":" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "juanje", name = "juan basura", dscr = "juan basura" },
    { t "basura" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "juanjo", name = "juanjo basura", dscr = "juanjo basura" },
    { t "" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "ind", name = "paragraph indent symbol", dscr = "paragraph indent symbol" },
    { t "¬" },
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),
  s(
    { trig = "_", name = "italic", dscr = "italic" },
    { t "_", i(1), t "_" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),
  s({ trig = "*", name = "bold", dscr = "bold" }, { t "*", i(1), t "*" }, {
    condition = function()
      return not typst.in_import()
    end,
    show_condition = typst.in_text,
  }),

  s(
    { trig = "mk", name = "math in line", dscr = "math in line" },
    { t "$", i(1), t "$" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "dm", name = "display math", dscr = "display math" },
    { t { "$", "  " }, i(1), t { "", "$" } },
    { condition = typst.in_text, expand.line_begin, show_condition = typst.in_text }
  ),

  s(
    { trig = "for", name = "for loop in text", dscr = "for loop in text" },
    fmt(
      [[
        #for <> in <> {
          <>
        }
        ]],
      { i(1), i(2), i(3) },
      { delimiters = "<>" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),

  s(
    { trig = "code", name = "code block", dscr = "code block" },
    fmt(
      [[
    ```<>
    <>
    ```
    ]],
      { i(1, "lang"), i(2, "code") },
      { delimiters = "<>" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),

  s(
    { trig = "list", name = "list", dscr = "list" },
    fmt(
      [[
    #list[
      <>
    ][<>]
    ]],
      { i(1), i(2) },
      { delimiters = "<>" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),
}

for _, env in ipairs(useful_envs) do
  table.insert(
    autosnips,
    s(
      { trig = env, name = env, dscr = env },
      fmt(
        [[
      #<>(
        "<>",
        [
          <>
        ]
      )<>
      ]],
        { t(env), i(1), i(2), i(0) },
        { delimiters = "<>" }
      ),
      { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
    )
  )
end

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
    snips,
    s({ trig = trig, name = text, dscr = dscr, wordTrig = word }, nodes, { condition = typst.in_mathzone })
  )
end

return snips, autosnips
