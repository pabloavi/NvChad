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
  -- templates
  s(
    {
      trig = "templatefig",
      name = "Basic template & figure support",
      dscr = "Create a latex document with figure support ",
    },
    fmt(
      [[ 
    \documentclass[a4paper,12pt]{article}
    
    \usepackage[utf8]{inputenc}
    \usepackage[T1]{fontenc}
    \usepackage{textcomp}
    \usepackage[spanish]{babel}
    \usepackage{amsmath, amssymb}
    \usepackage{bm}
    \usepackage[a4paper,margin=2.25cm]{geometry}
    \usepackage{enumitem}
    \setlist{
    	listparindent=\parindent,
    	% parsep=0pt,
    }

    
    
    % figure support
    \usepackage{import}
    \usepackage{xifthen}
    \pdfminorversion=7
    \usepackage{pdfpages}
    \usepackage{transparent}
    \newcommand{\incfig}[1]{%
    	\def\svgwidth{\columnwidth}
    	\import{./figures/}{#1.pdf_tex}
    }

    \usepackage{hyperref}
    \hypersetup{
        colorlinks=true,
        linkcolor=blue,
        filecolor=magenta,      
        urlcolor=cyan,
        pdftitle={<>},
        pdfpagemode=FullScreen,
    }
    
    \usepackage{mathtools}
    \newtagform{brackets}{[}{]}
    \usetagform{brackets}

    \usepackage{parskip}
    \setlength\parindent{24pt}
    
    \usepackage{libertine}

    
    % para nombrar los align usar \numberthis \label{...}
    \newcommand\numberthis{\addtocounter{equation}{1}\tag{\theequation}}

    \DeclareMathOperator{\diff}{\mathrm{d}\!}
    \DeclareMathOperator{\bdiff}{\mathchar'26\mkern-10mu\mathrm{d}\!}
    \DeclareMathOperator{\sen}{\mathrm{sen}}
    \DeclareMathOperator{\senh}{\mathrm{senh}}

    \pdfsuppresswarningpagegroup=1
    
    \begin{document}
        \title{<>}
    	  \date{<>}
        \author{Pablo Avilés Mogío}
        \maketitle
        %
        \input{<>}
        %
    \end{document}
    ]],
      { i(1), rep(1), i(2), i(3) },
      { delimiters = "<>" }
    )
  ),

  s(
    {
      trig = "template",
      name = "Basic template",
      dscr = "Create a simple latex document",
    },
    fmt(
      [[ 
    \documentclass[a4paper,12pt]{article}
    
    \usepackage[utf8]{inputenc}
    \usepackage[T1]{fontenc}
    \usepackage{textcomp}
    \usepackage[spanish]{babel}
    \usepackage{amsmath, amssymb}
    \usepackage[a4paper,margin=2.25cm]{geometry}
    \usepackage{enumitem}
    \setlist{
    	listparindent=\parindent,
    	% parsep=0pt,
    }
    
    \DeclareMathOperator{\diff}{\mathrm{d}\!}
    \DeclareMathOperator{\bdiff}{\\mathchar'26\\mkern-10mu\\mathrm{d}\!}
    \DeclareMathOperator{\sen}{\mathrm{sen}}
    \DeclareMathOperator{\senh}{\mathrm{senh}}
    
    \pdfsuppresswarningpagegroup=1
    
    \begin{document}
    	<>
    \end{document}
    ]],
      { i(0) },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "templateform", name = "Template formulario", dscr = "Plantilla para formularios" },
    fmt(
      [[
      \documentclass[12pt,a4paper,landscape,oneside]{amsart}
      \usepackage{amsmath, amsthm, amssymb, amsfonts}
      \usepackage[utf8]{inputenc}
      \usepackage{booktabs}
      \usepackage{fancyhdr}
      \usepackage{float}
      \usepackage{fullpage}
      \usepackage[landscape]{geometry}
      \usepackage{caption, subcaption}
      \usepackage{graphicx}
      \usepackage{titling}
      \usepackage{multicol}
      \usepackage{hyperref}
      \usepackage{libertine}
      
      \usepackage{comment}
      \geometry{top=.5cm,left=.5cm,right=.5cm,bottom=.5cm}
      
      \setlength{\headheight}{15.2pt}
      \renewcommand{\headrulewidth}{0.4pt}
      \renewcommand{\footrulewidth}{0.4pt}
      
      \makeatletter
      \renewcommand{\section}{\@startsection{section}{1}{0mm}%
      	{-1ex plus -.5ex minus -.2ex}%
      	{0.5ex plus .2ex}%x
      	{\normalfont\large\bfseries}}
      \renewcommand{\subsection}{\@startsection{subsection}{2}{0mm}%
      	{-1explus -.5ex minus -.2ex}%
      	{0.5ex plus .2ex}%
      	{\normalfont\normalsize\bfseries}}
      \renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{0mm}%
      	{-1ex plus -.5ex minus -.2ex}%
      	{1ex plus .2ex}%
      	{\normalfont\small\bfseries}}
      \makeatother
      
      % Don't print section numbers
      \setcounter{secnumdepth}{0}
      
      \setlength{\parindent}{6pt}
      \setlength{\parskip}{0pt plus 0.5ex}
      
      \pagestyle{fancy}
      \lhead{Pablo Avilés Mogío - <>}
      \rhead{\thepage}
      \cfoot{}

      \DeclareMathOperator{\diff}{\mathrm{d}\!}
      \DeclareMathOperator{\bdiff}{\\mathchar'26\\mkern-10mu\\mathrm{d}\!}
      \DeclareMathOperator{\sen}{\mathrm{sen}}
      \DeclareMathOperator{\senh}{\mathrm{senh}}
      \renewcommand{\sin}{\sen}
      \renewcommand{\sinh}{\senh}
      
      \begin{document}
      \thispagestyle{fancy}
      \footnotesize
      \raggedcolumns
      \begin{multicols*}{3}
        <>	
      \end{multicols*}
      \end{document}
      ]],
      { i(1, "Asignatura"), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
}

return snips, autosnips
