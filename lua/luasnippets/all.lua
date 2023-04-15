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

local function neg(fn, ...)
  return not fn(...)
end

local function even_count(c)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, c, "")
  return ct % 2 == 0
end

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
  return ct1 == ct2
end

local function pair(pair_begin, pair_end, expand_func, ...)
  return s({ trig = pair_begin, wordTrig = false }, { t { pair_begin }, i(1), t { pair_end } }, {
    condition = part(expand_func, part(..., pair_begin, pair_end)),
    show_condition = function()
      return false
    end,
  })
end

snips = {
  -- s(
  --   { trig = "(", wordTrig = false, name = "parenthesis", dscr = "parenthesis" },
  --   fmt(
  --     [[
  --     (<>)<>
  --     ]],
  --     { i(1), i(0) },
  --     { delimiters = "<>" }
  --   ),
  --   { condition = char_count_same("%(", "%)") }
  -- ),
  pair("(", ")", neg, char_count_same),
  pair("{", "}", neg, char_count_same),
  pair("[", "]", neg, char_count_same),
  pair("¿", "?", neg, char_count_same),
  -- pair("<", ">", neg, char_count_same),
  pair("'", "'", neg, even_count),
  pair('"', '"', neg, even_count),
  pair("`", "`", neg, even_count),
}

autosnips = {
  -- vv is <, nn is >, low priority
  s({ trig = "vv", wordTrig = false, name = "<", dscr = "less than", priority = 50 }, { t "<", i(0) }),
  s({ trig = "nn", wordTrig = false, name = ">", dscr = "greater than", priority = 50 }, { t ">", i(0) }),
}

return snips, autosnips
