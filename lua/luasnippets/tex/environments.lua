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

local useful_envs = {
  ["demo"] = "demo",
  ["nota"] = "nota",
  ["defi"] = "definicion",
  ["teor"] = "teorema",
  ["ejem"] = "ejemplo",
  ["ejer"] = "ejercicio",
  ["postu"] = "postulado",
  ["capci"] = "pregunta_capciosa",
}

snips = {
  s(
    { trig = "eq", name = "equation", dscr = "create equation env" },
    fmt(
      [[
      \begin{equation}
        <>
        \label{eq:<>}
      <>\end{equation}

      <>]],
      { i(1), i(2), c(3, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "eqp", name = "equation*", dscr = "create equation* env" },
    fmt(
      [[
      \begin{equation*}
        <>
      <>\end{equation*}

      <>]],
      { i(1), c(2, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  -- subequations
  s(
    { trig = "subeqs", name = "subequations", dscr = "create subequations env" },
    fmt(
      [[
      \begin{subequations}
        \begin{equation}
          <>
          \label{eq:<>}
        \end{equation}
      <>\end{subequations}

      <>]],
      { i(1), i(2), c(3, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "gat", name = "gather", dscr = "create gather env" },
    fmt(
      [[
      \begin{gather}
        <>
        \label{eq:<>}
      <>\end{gather}

      <>]],
      { i(1), i(2), c(3, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "gatp", name = "gather*", dscr = "create gather* env" },
    fmt(
      [[
      \begin{gather*}
        <>
      <>\end{gather*}

      <>]],
      { i(1), c(2, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s("pac", {
    m(1, "^$", "\\usepackage", "\\usepackage["),
    i(1),
    n(1, "]"),
    m(1, "^$", "{", "{"),
    i(2),
    m(2, "^$", "}", "}"),
    i(0),
  }, { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }),

  s(
    { trig = "fig", name = "Figure environment" },
    fmt(
      [[
      \begin{figure}[htbp]
        \centering
        <>
        \caption{<>}
        \label{fig:<>}
      \end{figure}

      <>
    ]],
      {
        sn(1, {
          m(1, "^$", "\\includegraphics", "\\includegraphics[width="),
          i(1),
          n(1, "\\textwidth]"),
          m(1, "^$", "{figures/", "{figures/"),
          i(2),
          m(2, "^$", "}", "}"),
          i(0),
        }),
        i(2),
        i(3),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    { trig = "figp", name = "Figure environment", dscr = "Figure environment" },
    fmt(
      [[
      \begin{figure*}[htbp]
        \centering
        <>
      \end{figure*}

      <>
    ]],
      {
        sn(1, {
          m(1, "^$", "\\includegraphics", "\\includegraphics[width="),
          i(1),
          n(1, "\\textwidth]"),
          m(1, "^$", "{figures/", "{figures/"),
          i(2),
          m(2, "^$", "}", "}"),
          i(0),
        }),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    { trig = "2fig", name = "Two figures side by side", dscr = "Two figures side by side", priority = 1100 },
    fmt(
      [[
    \begin{figure}[htbp]
    \centering
    \begin{subfigure}{.5\textwidth}
      \centering
      <>
      \caption{<>}
      \label{fig:<>}
    \end{subfigure}%
    \begin{subfigure}{.5\textwidth}
      \centering
      <>
      \caption{<>}
      \label{fig:<>}
    \end{subfigure}
    \caption{<>}
    \label{fig:<>}
    \end{figure}
    <>
    ]],
      {
        sn(1, {
          m(1, "^$", "\\includegraphics", "\\includegraphics[width="),
          i(1),
          n(1, "\\textwidth]"),
          m(1, "^$", "{figures/", "{figures/"),
          i(2),
          m(2, "^$", "}", "}"),
          i(0),
        }),
        i(2),
        i(3),
        sn(4, {
          m(1, "^$", "\\includegraphics", "\\includegraphics[width="),
          i(1),
          n(1, "\\textwidth]"),
          m(1, "^$", "{figures/", "{figures/"),
          i(2),
          m(2, "^$", "}", "}"),
          i(0),
        }),
        i(5),
        i(6),
        i(7),
        i(8),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  -- TODO: check if this works
  s(
    { trig = "figs", name = "Loop with figures and subfigures", dscr = "Loop with figures and subfigures" },
    fmt(
      [[
    \begin{figure}[htbp]
    \centering
    \foreach \n in {<>}{
      \begin{subfigure}{<>\textwidth}
        \centering
        \includegraphics[width=<>\textwidth]{figures/<>_\n.png}
        \caption{<>}
        \label{fig:<>}
      \end{subfigure}%
    }
    \caption{<>}
    \label{fig:<>}
    \end{figure}
    <>
    ]],
      { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    { trig = "alip", name = "align*", dscr = "align* environment" },
    fmt(
      [[
      \begin{align*}
      & <> \\
      & <>
      <>\end{align*}
      <>
      ]],
      { i(1), i(2), c(3, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "ali", name = "align", dscr = "align environment" },
    fmt(
      [[
      \begin{align}
      & <> \\
      & <>
      <>\end{align}
      <>
      ]],
      { i(1), i(2), c(3, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s("incgra", {
    m(1, "^$", "\\includegraphics", "\\includegraphics[width="),
    i(1),
    n(1, "\\textwidth]"),
    m(1, "^$", "{figures/", "{figures/"),
    i(2),
    m(2, "^$", "}", "}"),
    i(0),
  }, { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }),

  s(
    { trig = "tab", name = "table", dscr = "table" },
    fmt(
      [[
    \begin{table}
      \centering
      <>
      \caption{<>}
      \label{tab:<>}
    \end{table}
    ]],
      { i(3), i(1), i(2) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
}

autosnips = {
  s(
    { trig = "mk", name = "Inline math", dscr = "Inline math mode" },
    fmt(
      [[
      \( <> \)<>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = "dm", name = "Display math", dscr = "Display math mode (block)" },
    fmt(
      [[
      \[
        <>
      <>\]
      <>
      ]],
      { i(1), c(2, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text * expand.line_begin }
  ),

  s(
    { trig = "beg", name = "begin{}, end{}", dscr = "begin{}, end{}" },
    fmt(
      [[
      \begin{<>}
      <>
      \end{<>}

      <>
      ]],
      { i(1), i(2), rep(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  -- NOTE: change to snips? or add ali and alip to autosnips?
  s(
    { trig = "case", name = "cases enviroment", dscr = "cases enviroment" },
    fmt(
      [[
      \[
      \begin{cases}
      <>, \\
      <>
      <>\end{cases}
      \]

      <>
      ]],
      { i(1), i(2), c(3, { t ".", t ",", t "" }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin * tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "mp", name = "minipage", dscr = "create minipage env" }, -- choice node
    fmt(
      [[
    \begin{minipage}{<>\textwidth}
      <>
    \end{minipage}]],
      { c(1, { t "0.5", t "0.45", t "0.33", i(nil) }), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin * tex.in_text, show_condition = tex.in_text }
  ),

  s({ trig = "-", name = "item", dscr = "Item in itemize or enumerate environment." }, { t "\\item" }, {
    condition = function()
      return tex.in_env "itemize" or tex.in_env "enumerate" and not tex.in_mathzone()
    end * expand.line_begin,
  }),
  s({ trig = ".-", name = "subitem", dscr = "Subitem in itemize or enumerate environment." }, { t "\\subitem" }, {
    condition = function()
      return tex.in_env "itemize" or tex.in_env "enumerate" and not tex.in_mathzone()
    end * expand.line_begin,
  }),
  s({ trig = "sub", name = "subitem", dscr = "Subitem in itemize or enumerate environment." }, { t "\\subitem" }, {
    condition = function()
      return tex.in_env "itemize" or tex.in_env "enumerate" and not tex.in_mathzone()
    end * expand.line_begin,
  }),

  s(
    { trig = "enum", name = "enumerate", dscr = "Enumerate environment." },
    fmt(
      [[ 
      \begin{enumerate}<>
        \item <> 
      \end{enumerate}

      <> 
      ]],
      {
        sn(1, {
          m(1, "^$", "", "[label=\\"),
          c(1, {
            t "",
            t "arabic*",
            t "alph*",
            t "Alph*",
            t "roman*",
            t "Roman*",
          }),
          n(1, "]"),
        }, { delimiters = "<>" }),
        i(2),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "item", name = "item", dscr = "Itemize environment." },
    fmt(
      [[ 
      \begin{itemize} 
        \item <>
      \end{itemize}

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin, show_condition = tex.in_text }
  ),
  -- circuitikz figure
  s(
    { trig = "circuit", name = "circuitikz", dscr = "circuitikz figure" },
    fmt(
      [[
      \begin{figure}[htbp]
      	\centering
      	\begin{circuitikz}[american voltages] \draw
          <>
      		;
      	\end{circuitikz}
      	\caption{<>}
      	\label{fig:<>}
      \end{figure}

      <>
      ]],
      { i(1), i(2), i(3), i(0) },
      { delimiters = "<>" }
    ),
    {
      condition = function()
        return not tex.in_circuitikz() and tex.in_text()
      end * expand.line_begin,
      show_condition = tex.in_text,
    }
  ),
}

for envname, envname_sp in pairs(useful_envs) do
  table.insert(
    snips,
    s(
      { trig = envname, name = envname_sp, dscr = "create " .. envname_sp .. " env" },
      fmt(
        [[
        \begin{<>}<>
          <>
        \end{<>}
        <>
        ]],
        {
          t(envname_sp),
          sn(1, {
            m(1, "^$", "", "["),
            i(1),
            n(1, "]"),
          }, { delimiters = "<>" }),
          i(2),
          t(envname_sp),
          i(0),
        },
        { delimiters = "<>" }
      ),
      { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
    )
  )
  table.insert(
    snips,
    s(
      { trig = envname .. "p", name = envname_sp .. "*", dscr = "create " .. envname_sp .. "* env" },
      fmt(
        [[
        \begin{<>*}<>
          <>
        \end{<>*}
        <>
        ]],
        {
          t(envname_sp),
          sn(1, {
            m(1, "^$", "", "["),
            i(1),
            n(1, "]"),
          }, { delimiters = "<>" }),
          i(2),
          t(envname_sp),
          i(0),
        },
        { delimiters = "<>" }
      ),
      { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
    )
  )
end

return snips, autosnips
