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
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

snips = {
  s(
    { trig = "keygroup", name = "awful add several few keybindings", dscr = "awful add several few keybindings" },
    fmt(
      [[
      awful.keyboard.append_global_keybindings {
        <>
      }<>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),
  s(
    { trig = "keybind", name = "awful add keybinding", dscr = "awful add keybinding" },
    fmt(
      [[
        awful.key {
          modifiers = {<>},
          key = "<>",
          description = "<>",
          group = "<>",
          on_press = <>,
        },<>
        ]],
      { i(1), i(2), i(3), i(4), i(5), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),
  s({ trig = "super", name = "super modkey", dscr = "super modkey" }, { t "mod.super" }),
  s({ trig = "shift", name = "shift modkey", dscr = "shift modkey" }, { t "mod.shift" }),
  s({ trig = "alt", name = "alt modkey", dscr = "alt modkey" }, { t "mod.alt" }),
  s({ trig = "ctrl", name = "ctrl modkey", dscr = "ctrl modkey" }, { t "mod.ctrl" }),
}

autosnips = {}

return snips, autosnips
