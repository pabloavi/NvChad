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
    condition = typst.not_in_import, -- part(expand_func, part(..., pair_begin, pair_end)),
    show_condition = function()
      return false
    end,
  })
end

snips = {
  -- "preamble"
  s(
    { trig = "setupsen", name = "setup sen operators", dscr = "setup sen operators" },
    fmt(
      [[
    #let sen = math.op("sen")
    #let asen = math.op("asen")
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
      ) <img-{}>

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
      ) <tab-{}>

      {}
    ]],
      { i(1), i(2), i(3), i(0) },
      { delimiters = "{}" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),
}

autosnips = {
  pair("$", "$", neg, char_count_same),

  s(
    { trig = "_", name = "italic", dscr = "italic" },
    { t "_", i(1), t "_" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),
  s(
    { trig = "*", name = "bold", dscr = "bold" },
    { t "*", i(1), t "*" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "mk", name = "math in line", dscr = "math in line" },
    { t "$", i(1), t "$" },
    { condition = typst.in_text, show_condition = typst.in_text }
  ),

  s(
    { trig = "dm", name = "display math", dscr = "display math" },
    { t "$ ", i(1), t " $" },
    { condition = typst.in_text, expand.line_begin, show_condition = typst.in_text }
  ),

  s(
    { trig = "/", name = "fraction", dscr = "fraction" },
    { t "(", i(1), t ")/(", i(2), t ") " },
    { condition = typst.in_mathzone, show_condition = typst.in_mathzone }
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
}

return snips, autosnips
