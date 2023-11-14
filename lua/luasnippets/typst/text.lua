local snips, autosnips = {}, {}

local typst = {}

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

typst.in_mathzone = function()
  return vim.fn["typst#in_math"]() == 1
end

typst.in_comment = function()
  return vim.fn["typst#in_comment"]() == 1
end

typst.in_code = function()
  return vim.fn["typst#in_code"]() == 1
end

typst.in_markup = function()
  return vim.fn["typst#in_markup"]() == 1
end

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
    condition = typst.in_markup, -- part(expand_func, part(..., pair_begin, pair_end)),
    show_condition = function()
      return false
    end,
  })
end

snips = {
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
    { condition = typst.in_markup * expand.line_begin, show_condition = typst.in_markup }
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
    { condition = typst.in_markup * expand.line_begin, show_condition = typst.in_markup }
  ),
}

autosnips = {
  -- pair("$", "$", neg, char_count_same),
  pair("*", "*", neg, char_count_same),
  pair("_", "_", neg, char_count_same),

  s(
    { trig = "mk", name = "math in line", dscr = "math in line" },
    { t "$", i(1), t "$" },
    { condition = typst.in_markup, show_condition = typst.in_markup }
  ),

  s(
    { trig = "dm", name = "display math", dscr = "display math" },
    { t "$ ", i(1), t " $" },
    { condition = typst.in_markup, expand.line_begin, show_condition = typst.in_markup }
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
    { condition = typst.in_markup * expand.line_begin, show_condition = typst.in_markup }
  ),
}

return snips, autosnips
