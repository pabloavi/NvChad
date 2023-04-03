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
    { trig = "online", name = "online/web citation", dscr = "online/web citation" },
    fmt(
      [[
    @online{<>:<>,
      author = {<>},
      title = {<>},
      year = {<>},
      url = {<>},
      urldate = {<>},
    }
    <>
    ]],
      { i(1, "author"), i(2, "year"), i(3, "author"), i(4, "title"), i(5, "year"), i(6, "url"), i(7, "urldate"), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),

  -- s(
  --   { trig = "article", name = "article citation", dscr = "article citation" },
  --   fmt(
  --     [[
  --   @article{<>,
  --     author = {<>},
  --     title = {<>},
  --     journal = {<>},
  --     volume = {<>},
  --     number = {<>},
  --     pages = {<>},
  --     year = {<>},
  --     month = {<>},
  --     note = {<>},
  --   }
  --   <>
  --   ]],
  --     {
  --       i(1, "label"),
  --       i(2, "author"),
  --       i(3, "title"),
  --       i(4, "journal"),
  --       i(5, "volume"),
  --       i(6, "number"),
  --       i(7, "pages"),
  --       i(8, "year"),
  --       i(9, "month"),
  --       i(10, "note"),
  --       i(0),
  --     },
  --     { delimiters = "<>" }
  --   ),
  --   { condition = expand.line_begin }
  -- ),
  --
  -- s(
  --   { trig = "book", name = "book citation", dscr = "book citation" },
  --   fmt(
  --     [[
  --   @book{<>,
  --     author = {<>},
  --     title = {<>},
  --     publisher = {<>},
  --     volume = {<>},
  --     series = {<>},
  --     address = {<>},
  --     edition = {<>},
  --     year = {<>},
  --     month = {<>},
  --     note = {<>},
  --   }
  --     ]],
  --     {
  --       i(1, "label"),
  --       i(2, "author"),
  --       i(3, "title"),
  --       i(4, "publisher"),
  --       i(5, "volume"),
  --       i(6, "series"),
  --       i(7, "address"),
  --       i(8, "edition"),
  --       i(9, "year"),
  --       i(10, "month"),
  --       i(11, "note"),
  --       i(0),
  --     },
  --     { delimiters = "<>" }
  --   ),
  --   { condition = expand.line_begin }
  -- ),
  --
  -- s(
  --   { trig = "inbook", name = "inbook citation", dscr = "inbook citation" },
  --   fmt(
  --     [[
  --   @inbook{<>,
  --     author = {<>},
  --     editor = {<>},
  --     title = {<>},
  --     chapter = {<>},
  --     pages = {<>},
  --     publisher = {<>},
  --     volume = {<>},
  --     number = {<>},
  --     series = {<>},
  --     type = {<>},
  --     address = {<>},
  --     edition = {<>},
  --     year = {<>},
  --     month = {<>},
  --     note = {<>},
  --     ]],
  --     {
  --       i(1, "label"),
  --       i(2, "author"),
  --       i(3, "editor"),
  --       i(4, "title"),
  --       i(5, "chapter"),
  --       i(6, "pages"),
  --       i(7, "publisher"),
  --       i(8, "volume"),
  --       i(9, "number"),
  --       i(10, "series"),
  --       i(11, "type"),
  --       i(12, "address"),
  --       i(13, "edition"),
  --       i(14, "year"),
  --       i(15, "month"),
  --       i(16, "note"),
  --       i(0),
  --     },
  --     { delimiters = "<>" }
  --   ),
  --   { condition = expand.line_begin }
  -- ),
}

return snips, autosnips
