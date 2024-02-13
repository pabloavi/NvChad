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
local matches = require("luasnip.extras.postfix").matches

snips = {
  -- with open as
  s(
    { trig = "open", name = "with open as", dscr = "with open as" },
    fmt(
      [[
      with open("<>", "<>") as <>:
          <>
      ]],
      { i(1), c(2, { t "r", t "f", {} }), i(3, "f"), i(0, "pass") },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),

  -- s(
  --   { trig = "plotcolor", name = "Dont repeat colors in multiplot", dscr = "Dont repeat colors in multiplot" },
  --   fmt(
  --     [[
  --     NUM_COLORS = <>
  --
  --     cm = plt.get_cmap("gist_rainbow")
  --     fig = plt.figure()
  --     ax = fig.add_subplot(111)
  --     ax.set_prop_cycle(color=[cm(1.0 * i / NUM_COLORS) for i in range(NUM_COLORS)])
  --     <>
  --     ]],
  --     { i(1), i(0) },
  --     { delimiters = "<>" }
  --   ),
  --   { condition = expand.line_begin, show_condition = expand.line_begin }
  -- ),

  -- templateplot
  s(
    { trig = "templateplot", name = "plot template file", dscr = "plot template file" },
    fmt(
      [[
      import numpy as np
      import matplotlib
      import matplotlib.pyplot as plt
      
      # latex libertine font
      plt.rc("text", usetex=True)
      plt.rc("font", family="libertine")
      plt.rc(
          "text.latex",
          preamble=r"\usepackage{libertine}\usepackage[separate-uncertainty=true]{siunitx}\usepackage{babel}",
      )
      matplotlib.rcParams.update({"font.size": 22})
      matplotlib.rcParams.update({"errorbar.capsize": 5})

      
      # 16:9
      plt.rcParams["figure.figsize"] = (16, 9)
      
      def typical_error(x):
          """Returns the tipical error of x"""
          return np.std(x) / np.sqrt(len(x))

      <>

      for fig in plt.get_fignums():
          plt.figure(fig)
          plt.tight_layout()
          plt.show()
          # plt.savefig("fig" + str(fig) + ".png")
    ]],
      { i(1) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),

  -- simulation plot
  s(
    { trig = "simplot", name = "simulation plot", dscr = "simulation plot" },
    fmt(
      [[
      plt.figure(<>)
      plt.title(r"<>")
      plt.xlabel(r"<>")
      plt.ylabel(r"<>")
      plt.grid(True)
      plt.plot(<>)
      plt.legend(<>)
      plt.tight_layout()
    ]],
      { i(1), i(2), i(3), i(4), i(5), i(6) },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),

  -- fit plot (plot with fit and points)
  s(
    { trig = "fitplot", name = "fit plot", dscr = "fit plot" },
    fmt(
      [[
      fit_fn = np.poly1d(np.polyfit(<>, <>, 1))
      R2 = np.corrcoef(<>, fit_fn(<>))[0, 1] ** 2

      plt.figure(<>)
      plt.title(r"<>")
      plt.xlabel(r"<>")
      plt.ylabel(r"<>")
      plt.grid(True)
      plt.errorbar(<>, <>, xerr=typical_error(<>), yerr=typical_error(<>), fmt="o", color="b")
      plt.plot(<>, fit_fn(<>), "<>--")
      plt.legend(
          [
              r"Ajuste lineal $R^2 = {:.3f}$, $m = {:.4f}, n = {:.4f}$".format(
                  R2, fit_fn[1], fit_fn[0]
              ),
              r"Datos experimentales",
          ],
      )
      plt.tight_layout()
    ]],
      {
        i(1, "x"),
        i(2, "y"),
        rep(2),
        rep(1),
        i(3),
        i(3),
        i(4),
        i(5),
        rep(1),
        rep(2),
        rep(1),
        rep(2),
        rep(1),
        rep(1),
        i(6),
      },
      { delimiters = "<>" }
    ),
    { condition = expand.line_begin }
  ),

  -- converts the line to print(line) using lambda
  postfix({ trig = ".p", match_pattern = matches.line }, { l("print(" .. l.POSTFIX_MATCH .. ")") }),
}

autosnips = {}

return snips, autosnips
