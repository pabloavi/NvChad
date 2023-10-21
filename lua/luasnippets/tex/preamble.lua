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

snips = {

  -- make title space smaller
  s(
    { trig = "titlesmall", name = "make title smaller", dscr = "make title smaller" },
    { t { "\\usepackage{titling}", "\\setlength{\\droptitle}{-5em}" } },
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    { trig = "setupsiunitx", name = "Setup siunitx (spanish)", dscr = "Setup siunitx (spanish)" },
    fmt(
      [[
      \usepackage[separate-uncertainty = true]{siunitx}
      \sisetup{range-phrase = --}
      <>
      ]],
      { i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  -- setup differential
  s(
    { trig = "setupdiff", name = "Setup differential", dscr = "Setup differential" },
    fmt(
      [[
      \DeclareMathOperator{\diff}{\mathrm{d}\!}
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  -- broken difff
  s(
    { trig = "setupbdiff", name = "Setup inexact differential", dscr = "Setup inexact differential" },
    fmt(
      [[
      \DeclareMathOperator{\bdiff}{\\mathchar'26\\mkern-10mu\\mathrm{d}\!}
    ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  -- setup sen and senh
  s(
    { trig = "setupsen", name = "Setup sen and senh", dscr = "Setup sen and senh" },
    fmt(
      [[
      \DeclareMathOperator{\sen}{\mathrm{sen}}
      \DeclareMathOperator{\senh}{\mathrm{senh}}
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "setupboldvec", name = "Setup bold vector", dscr = "Setup bold vector" },
    fmt(
      [[
      \renewcommand{\vec}[1]{\bm{#1}}
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "setupTensor", name = "Setup Tensor", dscr = "Setup Tensor" },
    fmt(
      [[
      \newcommand{\Tensor}[1]{\bm{\tilde{#1}}}
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    { trig = "setupgriffiths", name = "setup griffiths-like font", dscr = "setup griffiths-like font" },
    fmt(
      [[
      \usepackage{newtxtext,newtxmath} % griffiths style
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "setuppara", name = "setup paragraph indent", dscr = "setup paragraph indent" },
    fmt(
      [[
    \usepackage{parskip}
    \setlength\parindent{24pt}
    ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    {
      trig = "setupnabla",
      name = "Setup nabla operator commands",
      dscr = "Setup nabla operator commands: grad, div, rot, lapl",
    },
    fmt(
      [[
      \newcommand{\grad}{\nabla}
      \renewcommand{\div}{\nabla\cdot}
      \newcommand{\rot}{\nabla\times}
      \newcommand{\lapl}{\nabla^2}
      <>
    ]],
      { i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  -- setup double and triple dot products
  s(
    { trig = "setupdot", name = "Setup dot products", dscr = "Setup dot products" },
    fmt(
      [[
      % productos escalares dobles y triples
      \def\onedot{$\mathsurround0pt\ldotp$}
      \def\cddot{% two dots stacked vertically
      	\mathbin{\vcenter{\baselineskip.67ex
      			\hbox{\onedot}\hbox{\onedot}}%
      	}}%
      \def\cdddot#1{% three dots 
      	\mathbin{\vcenter{\baselineskip.67ex
      			\hbox{\onedot}\hbox{\onedot}\hbox{\onedot}%
      		}}%
      }
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    {
      trig = "setupbabeltabla",
      name = "change all appearances of cuadro with tabla in babel",
      dscr = "change all appearances of cuadro with tabla in babel",
    },
    fmt(
      [[
      \addto\captionsspanish{\renewcommand{\tablename}{Tabla}}
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),

  s(
    { trig = "decmo", name = "Declare math operator", dscr = "Declare math operator" },
    fmt(
      [[
      \DeclareMathOperator{\<>}{<>}<>
      ]],
      { i(1, "Nombre"), i(2, "expr."), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "setupgeometry", name = "geometry package", dscr = "geometry package" },
    fmt(
      [[
    \usepackage[a4paper,margin=2.25cm]{geometry}
    ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  -- newthm
  s(
    { trig = "setupthm", name = "newtheorem boxes", dscr = "newtheorem boxes" },
    fmt(
      [[
      % START BOXES
      \usepackage{floatrow} % to place figures inside boxes
      \usepackage{thmtools}
      \usepackage[framemethod=TikZ]{mdframed}
      \mdfsetup{skipabove=1em,skipbelow=0em, innertopmargin=5pt, innerbottommargin=6pt}
      
      \theoremstyle{definition}
      \makeatletter
      \declaretheoremstyle[headfont=\bfseries\sffamily, bodyfont=\normalfont, mdframed={ nobreak }, numbered=no]{thmgraybox}
      \declaretheoremstyle[headfont=\bfseries\sffamily, bodyfont=\normalfont, numbered=no, mdframed={ nobreak, rightline=false, topline=false, bottomline=false } ]{thmleftline}
      <>
      \makeatother
      % END BOXES
    ]],
      { i(1) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "thmbox", name = "Squared box", dscr = "Squared box" },
    fmt(
      [[
      \declaretheorem[style=thmgraybox, name=<>]{<>}
    ]],
      { l(l._1:gsub("^%l", string.upper), 1), i(1) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),
  s(
    { trig = "thmleft", name = "Left line box", dscr = "Left line box" },
    fmt(
      [[
      \declaretheorem[style=thmleftline, name=<>]{<>}
    ]],
      { l(l._1:gsub("^%l", string.upper), 1), i(1) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text }
  ),

  s(
    { trig = "setup11", name = "setup double 1 with mathbb", dscr = "setup double 1 with mathbb" },
    fmt(
      [[
      \declaremathalphabet{\mymathbb}{u}{boondox-ds}{m}{n}
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
}

autosnips = {}

return snips, autosnips
