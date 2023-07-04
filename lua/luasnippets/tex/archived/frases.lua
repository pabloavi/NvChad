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

local abbreviations = {
  -- { "inc.", "incendio" },
  -- { "incs", "incendios" },
  -- { "resp", "respectivamente" },
  -- { "etc", "etcétera" },
  -- { "dem", "de este modo" },
  -- { "spg", "sin pérdida de generalidad" },
  -- { "eca", "en cuanto a" },
  -- { "epq", "es por ello que" },
}

-- function that adds two snippets to the table: one with the given name and one with the first letter capitalized
local function add_abbreviation(input, output)
  table.insert(
    autosnips,
    s({ trig = input, name = "abreviatura", dsrc = "Abreviatura" }, {
      t(output),
    }, { condition = tex.in_text })
  )
  table.insert(
    autosnips,
    s({ trig = input:sub(1, 1):upper() .. input:sub(2), name = "abreviatura", dsrc = "Abreviatura" }, {
      t(output:sub(1, 1):upper() .. output:sub(2)),
    }, { condition = tex.in_text })
  )
end

snips = {}

autosnips = {}

for _, abbr in ipairs(abbreviations) do
  add_abbreviation(abbr[1], abbr[2])
end

return snips, autosnips
