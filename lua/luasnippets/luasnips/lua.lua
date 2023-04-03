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

  -- format snippet
  s(
    "snipf",
    fmt(
      [[ 
      s({ trig='<>', name='<>', dscr='<>'},    
        fmt(<>,
        { <> },
        { delimiters='<>' }
        ),
        { condition = <>, show_condition = <> }),
      <>
      ]],
      {
        i(1, "trigger"),
        i(2, "name"),
        rep(2),
        i(3, "fmt"),
        i(4, "inputs"),
        i(5, "<>"),
        i(6, "condition"),
        rep(6),
        i(0),
      },
      { delimiters = "<>" }
    )
  ),
  -- simple text snippet
  s(
    "snipt",
    fmt(
      [[ 
      s(
        { trig = "<>", name = "<>", dscr = "<>" },
        { t "<>"<> },
        { condition = <>, show_condition = <> }
      ),
      ]],
      { i(1), i(2), rep(2), i(3), i(4), i(5, "condition"), rep(5) },
      { delimiters = "<>" }
    )
  ),
  -- math snippet
  s(
    { trig = "snipm", name = "math snippet", dscr = "Creates a snippet template with math context" },
    fmt(
      [[
      s(
        { trig = "<>", name = "<>", dscr = "<>" },
        { t "<>" },
        { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
      ),
      <>
      ]],
      { i(1, "trigger"), i(2, "name"), rep(2), i(3), i(0) },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "snippf", name = "snip postfix", dscr = "Creates a snippet template for postfix (lambda)" },
    fmt(
      [[
  postfix("<>", { l("\\<>{" .. l.POSTFIX_MATCH .. "}") }, { condition = <> }),
    ]],
      { i(1, "trigger"), i(2, "start"), i(3, "math") },
      { delimiters = "<>" }
    )
  ),
  s("linebeg", { t "expand.line_begin " }),
  s("textext", { t "tex.in_text " }),
  s("texmath", { t "tex.in_mathzone " }),
  s("t", { t 't"', i(1), t '",' }),
  s("fn", { t "f(function(_, snip) ", i(1), t " end)" }),

  s("reg", { t "regTrig = true" }),
  s("wor", { t "wordTrig = false" }),
  s(
    { trig = "sc([%d])", name = "snip captures", dscr = "snip captures", regTrig = true },
    { t "snip.captures[", f(function(_, snip)
      return snip.captures[1]
    end), t "]" }
  ),

  -- s("i", { t "i(", i(1), t "), ", i(0) }),
}

autosnips = {
  s(
    { trig = "i(%d) ", regTrig = true, name = "auto index", dscr = "automatic indexes in snippets" },
    fmt([[i(<>), ]], { f(function(_, snip)
      return snip.captures[1]
    end) }, { delimiters = "<>" })
  ),
  s(
    { trig = "i(%d),", regTrig = true, name = "auto index with ,", dscr = "automatic indexes in snippets" },
    fmt(
      [[i(<>, "<>"), <>]],
      { f(function(_, snip)
        return snip.captures[1]
      end), i(1, "text"), i(0) },
      { delimiters = "<>" }
    )
  ),
  s(
    { trig = "rep(%d)", regTrig = true, name = "auto rep index with ,", dscr = "automatic rep indexes in snippets" },
    fmt([[rep(<>), <>]], { f(function(_, snip)
      return snip.captures[1]
    end), i(0) }, { delimiters = "<>" })
  ),

  s(
    { trig = "rowcond", name = "condition", dscr = "condition snippet" },
    fmt(
      [[
      { condition = <>, show_condition = <> })<>
      ]],
      { i(1), rep(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin, show_condition = expand.line_begin }
  ),
  s(
    { trig = "rowde", name = "delimiters row", dscr = "delimiters row" },
    fmt(
      [[
      { delimiters = "<>" }
      <>
      ]],
      { i(1, "<>"), i(0) },
      { delimiters = "<>" }
    )
  ),
  s("del", { t "<>" }),

  s(
    { trig = "texplate", name = "tex template for snippets", dscr = "tex template for snippets" },
    fmt(
      [[
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

        snips = {
        <>
        }

        autosnips = {
        <>
        }

        if enabled then
          return snips, autosnips
        end

        return nil, nil
    ]],
      { i(1), i(2) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin, show_condition = expand.line_begin }
  ),
}

return snips, autosnips
