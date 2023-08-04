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
  -- \begin{figure}[htpb]
  -- 	\centering
  -- 	\begin{tikzpicture}
  -- 		\begin{axis}[
  -- 				xlabel=labelx,
  -- 				ylabel=labely,
  -- 			]
  -- 			\addplot[color=red,mark=x] ${0};
  -- 		\end{axis}
  -- 	\end{tikzpicture}
  -- 	\caption{${2}}
  -- 	\label{fig:${1}}
  -- \end{figure}
  s(
    { trig = "plot", name = "pgfplot figure", dscr = "pgfplot figure" },
    fmt(
      [[
      \begin{figure}[htpb]
        \centering
        \begin{tikzpicture}
          \begin{<>}[
              xlabel=<>,
              ylabel=<>,
              axis lines = <>
            ]
            <>
          \end{<>}
        \end{tikzpicture}
        \caption{<>}
        \label{fig:<>}
      \end{figure}
      ]],
      {
        c(1, { t "axis", t "semilogxaxis", t "semilogyaxis", t "loglogaxis" }),
        i(2),
        i(3),
        c(4, { t "box", t "middle", t "none", t "left", t "right" }),
        i(5, "addplot"),
        rep(1),
        i(6),
        i(7),
      },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin * tex.in_text, show_condition = tex.in_text }
  ),
}

autosnips = {
  s({ trig = "fplot", name = "simple function pgfplots", dscr = "simple function pgfplots" }, {
    t "\\addplot[color=",
    c(1, { t "blue", t "red", t "green", t "yellow", i(nil) }),
    t "]",
    t " {",
    i(2),
    t "};",
    i(3),
  }, { condition = tex.in_axis * expand.line_begin, show_condition = tex.in_axis }),

  s({ trig = "plot", name = "simple function pgfplots", dscr = "simple function pgfplots" }, {
    t "\\addplot[only marks, mark=",
    c(1, { t "*", t "asterisk", t "star", t "diamond", t "cubes", t "triangle", t "oplus", t "otimes", t "" }),
    t ", color=",
    c(2, { t "blue", t "red", t "green", t "yellow", i(nil) }),
    t "]",
    t " {",
    i(3),
    t "};",
    i(4),
  }, { condition = tex.in_axis * expand.line_begin, show_condition = tex.in_axis }),

  s(
    { trig = "leg", name = "legend pgfplots", dscr = "legend pgfplots" },
    fmt(
      [[
      \legend{<>}
      ]],
      { i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_axis * expand.line_begin, show_condition = tex.in_axis }
  ),
}

if enabled then
  return snips, autosnips
end

return nil, nil
