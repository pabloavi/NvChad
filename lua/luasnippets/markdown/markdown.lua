local snips, autosnips = {}, {}

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
    { trig = "bf", name = "bold", dscr = "bold" },
    fmt(
      [[
    **<>**<>
    ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "it", name = "italic", dscr = "italic" },
    fmt(
      [[
      *<>*<>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "co", name = "code", dscr = "code" },
    fmt(
      [[
      `<>`<>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "co", name = "codeblock", dscr = "codeblock", priority = 200 },
    fmt(
      [[
    ```<>
    ```
    <>
    ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),
}

autosnips = {}

return snips, autosnips
