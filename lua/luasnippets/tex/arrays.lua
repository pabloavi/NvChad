local snips, autosnips = {}, {}

local tex = vim.g.use_treesitter and require "luasnippets.tex.utils.ts_utils" or require "luasnippets.utils.tex.utils"

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

-- LFG tables and matrices work
local tab = function(args, snip)
  local rows = tonumber(snip.captures[1])
  local cols = tonumber(snip.captures[2])
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t " & ")
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t { "\\\\", "" })
    if j == 1 then
      table.insert(nodes, t { "\\midrule", "" })
    end
  end
  return sn(nil, nodes)
end

-- yes this is a ripoff
local mat = function(args, snip)
  local rows = tonumber(snip.captures[2])
  local cols = tonumber(snip.captures[3])
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t " & ")
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t { "\\\\", "" })
  end
  nodes[#nodes] = t "\\\\"
  return sn(nil, nodes)
end

snips = {
  s(
    { trig = "([bBpvV])mat(%d+)x(%d+)", regTrig = true, name = "Matrix", dscr = "Dynamic matrix snippet" },
    fmt(
      [[
      \begin{<>}
      <>
      \end{<>}]],
      {
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
        d(1, mat),
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
      },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "tab(%d+)x(%d+)", regTrig = true, name = "test for tabular", dscr = "test" },
    fmt(
      [[
    \begin{tabular}{@{}<>@{}}
    \toprule
    <>
    \bottomrule
    \end{tabular}]],
      { f(function(_, snip)
        return string.rep("c", tonumber(snip.captures[2]))
      end), d(1, tab) },
      { delimiters = "<>" }
    )
  ),
}

autosnips = {
  s({ trig = "topr", name = "toprule", dscr = "toprule" }, { t "\\toprule" }, {
    condition = function()
      return tex.in_table
    end,
    show_condition = function()
      return tex.in_table
    end,
  }),
  s({ trig = "midr", name = "midrule", dscr = "midrule" }, { t "\\midrule" }, {
    condition = function()
      return tex.in_table
    end,
    show_condition = function()
      return tex.in_table
    end,
  }),
  s({ trig = "botr", name = "bottomrule", dscr = "bottomrule" }, { t "\\bottomrule" }, {
    condition = function()
      return tex.in_table
    end,
    show_condition = function()
      return tex.in_table
    end,
  }),
  s(
    { trig = "mcol", name = "multicolumn", dscr = "multicolumn" },
    fmt(
      [[
      \multicolumn{<>}{<>}{<>}
      ]],
      { i(1), i(2), i(3) },
      { delimiters = "<>" }
    ),
    {
      condition = function()
        return tex.in_table
      end,
      show_condition = function()
        return tex.in_table
      end,
    }
  ),
  s(
    { trig = "multirow", name = "multirow", dscr = "multirow" },
    fmt(
      [[
    \multirow{<>}{<>}{<>}
    ]],
      { i(1), i(2), i(3) },
      { delimiters = "<>" }
    ),
    {
      condition = function()
        return tex.in_table
      end,
      show_condition = function()
        return tex.in_table
      end,
    }
  ),
}

return snips, autosnips
