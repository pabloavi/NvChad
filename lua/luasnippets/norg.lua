local enabled = true
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

snips = {}

autosnips = {
  s(
    { trig = "meta", name = "document meta", dscr = "document meta" },
    fmt(
      [[
    @document.meta
    title: <>
    description: <>
    author: <>
    categories: <>
    created: <>
    version: <>
    @end
    ]],
      { i(1), i(2), i(3, "Pablo Avilés"), i(4), i(5), i(6, "0.1") },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin, show_condition = expand.line_begin }
  ),
  -- -. --> - [ ]
  s(
    { trig = "-.", name = "todo", dscr = "todo", wordTrig = false },
    fmt(
      [[
    - [ ] <>
    ]],
      { i(1) },
      { delimiters = "<>" }
    )
  ),
}

if enabled then
  return snips, autosnips
end

return nil, nil
