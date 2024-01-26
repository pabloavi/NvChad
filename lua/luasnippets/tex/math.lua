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
local fmta = require("luasnip.extras.fmt").fmta
local expand = require "luasnip.extras.conditions.expand"
local extras = require "luasnip.extras"
local m = extras.m
local n = extras.nonempty
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix
local matches = require("luasnip.extras.postfix").matches
local k = require("luasnip.nodes.key_indexer").new_key

local frac_no_parens = {
  f(function(_, snip)
    return string.format("\\frac{%s}", snip.captures[1])
  end, {}),
  t "{",
  i(1),
  t "} ",
  i(0),
}

local frac = s({
  priority = 1000,
  trig = ".*%)/",
  wordTrig = true,
  regTrig = true,
  name = "() frac",
}, {
  f(function(_, snip)
    local match = vim.trim(snip.trigger)

    local stripped = match:sub(1, #match - 1)

    i = #stripped
    local depth = 0
    while true do
      if stripped:sub(i, i) == ")" then
        depth = depth + 1
      end
      if stripped:sub(i, i) == "(" then
        depth = depth - 1
      end
      if depth == 0 then
        break
      end
      i = i - 1
    end

    local rv = string.format("%s\\frac{%s}", stripped:sub(1, i - 1), stripped:sub(i + 1, #stripped - 1))
    return rv
  end, {}),
  t "{",
  i(1),
  t "} ",
  i(0),
}, { condition = tex.in_mathzone, show_condition = tex.in_mathzone })

local vec_node = {
  f(function(_, snip)
    return string.format("\\vec{%s} ", snip.captures[1])
  end, {}),
}

local greek_letters = {
  "alpha",
  "beta",
  "gamma",
  "delta",
  "epsilon",
  "zeta",
  "eta",
  "theta",
  "iota",
  "kappa",
  "lambda",
  "mu",
  "nu",
  "xi",
  "omicron",
  "pi",
  "rho",
  "sigma",
  "tau",
  "upsilon",
  "phi",
  "chi",
  "psi",
  "omega",
  "nabla",
}

local operators = {
  "sin",
  "cos",
  "tan",
  "cot",
  "sec",
  "csc",
  "sinh",
  "cosh",
  "tanh",
  "coth",
  "sech",
  "csch",
  "log",
  "ln",
  "sen",
}

-- returns true if should insert space
-- local should_insert_space = function()
--   local characters = { " ", "}" }
--
--   local line = vim.api.nvim_get_current_line()
--   local column = vim.api.nvim_win_get_cursor(0)[2]
--   local next_char = line:sub(column - 1, column - 1)
--
--   return not vim.tbl_contains(characters, next_char)
-- end
--
-- local space_node = function()
--   return f(function(_, _)
--     return should_insert_space() and " " or ""
--   end, {})
-- end

snips = {
  s(
    { trig = "bm", name = "math bold", dscr = "Better bold in math mode." },
    { t "\\bm{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "rm", name = "math rm", dscr = "Better rm in math mode." },
    { t "\\mathrm{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "tt", name = "math text", dscr = "Insert text in math mode." },
    -- { t "\\ \\text{", i(1), t "}\\ " },
    { t "\\text{", i(1), t "}" },
    -- { c(1, { sn(nil, { t "\\text{", i(1), t "}" }), sn(nil, { t "\\ \\text{,", i(1), t "}\\" }) }) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "EE", name = "exists", dscr = "Exists" },
    { t "\\exists " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "AA", name = "forall", dscr = "Forall" },
    { t "\\forall " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- start vectorial spaces
  s(
    { trig = "RR", name = "Real numbers", dscr = "Real numbers" },
    { t "\\mathbb{R} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "QQ", name = "Rational numbers", dscr = "Rational numbers" },
    { t "\\mathbb{Q} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "ZZ", name = "Integers", dscr = "Integers" },
    { t "\\mathbb{Z} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "NN", name = "Natural numbers", dscr = "Natural numbers" },
    { t "\\mathbb{N} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "CC", name = "Complex numbers", dscr = "Complex numbers" },
    { t "\\mathbb{C} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "II", name = "Imaginary numbers", dscr = "Imaginary numbers" },
    { t "\\mathbb{I} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "HH", name = "Hilbert space", dscr = "Hilbert space" },
    { t "\\mathcal{H} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "OO", name = "Empty set", dscr = "Empty set" },
    { t "\\O " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "11", name = "1", dscr = "requires setup11 (double line one)" },
    { t "\\mymathbb{1} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- end vectorial spaces

  s(
    { trig = "ee", name = "exponential", dscr = "Exponential" },
    { t "\\exp{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "sume", name = "suma en un índice", dscr = "suma en un índice" },
    fmt(
      [[
      \sum_{<>} <>
      ]],
      { i(1, "i"), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "sum", name = "sum", dscr = "sum" },
    fmt(
      [[
      \sum_{<>=<>}^{<>} <>
      ]],
      { i(1, "n"), i(2, "1"), i(3, "\\infty"), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "taylor", name = "taylor", dscr = "Taylor series or expansion" },
    fmt(
      [[
      \sum_{<>=<>}^{<>} <>
      ]],
      { i(1, "k"), i(2, "0"), i(3, "\\infty"), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "lim", name = "limit", dscr = "limit" },
    { t "\\lim_{", i(1, "x"), t "\\to", i(2, "\\infty"), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "prod", name = "product", dscr = "product" },
    fmt(
      [[
      \prod_{<>=<>}^{<>} <>
      ]],
      { i(1, "n"), i(2, "1"), i(3, "\\infty"), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- start integrals
  -- s(
  --   { trig = "int", name = "integral", dscr = "integral", priority = 90 },
  --   { t "\\int ", i(1), t " \\diff ", i(2), t "\\, ", i(0) },
  --   { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  -- ),
  s(
    { trig = "int", name = "integral with choice", dscr = "integral with choice" },
    fmt(
      [[
    \int <> \diff <>
    ]],
      {
        c(1, {
          i(1),
          sn(nil, { t "_{", i(1), t "}^{", i(2), t "} ", i(3) }),
        }),
        i(2),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "ind", name = "integral", dscr = "integral", priority = 90 },
    { t "\\int \\diff ", i(1), t " \\, ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "intf", name = "integral", dscr = "integral", priority = 90 },
    { t "\\int_{", i(1, "-\\infty"), t "}^{", i(2, "\\infty"), t "}", i(3), t "\\diff ", i(4), t "\\," },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "indf", name = "integral", dscr = "integral", priority = 90 },
    { t "\\int_{", i(1, "-\\infty"), t "}^{", i(2, "\\infty"), t "} \\diff ", i(3), t "\\, ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- definite integral
  s(
    { trig = "dint", name = "definite integral", dscr = "Definite integral" },
    { t "\\int_{", i(1), t "}^{", i(2), t "}", i(3), t "\\diff ", i(4), t "\\," },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "dind", name = "definite integral", dscr = "Definite integral" },
    { t "\\int_{", i(1), t "}^{", i(2), t "} \\diff ", i(3), t "\\, ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "oint", name = "ointegral", dscr = "Closed integral" },
    { t "\\oint ", i(1), t " \\diff ", i(2), t "\\, ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "oind", name = "ointegral", dscr = "Closed integral" },
    { t "\\oint \\diff ", i(1), t "\\, ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
}

autosnips = {
  s(
    { trig = "hb", name = "h bar", dscr = "h bar quantum constant" },
    { t "\\hbar " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "eps0", name = "epsilon_0", dscr = "Electrical permitivity of vacuum epsilon_0" },
    { t "\\epsilon_0 " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\mu 0", name = "mu_0", dscr = "Magnetic permitivity of vacuum mu_0" },
    { t "\\mu_0 " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "kb", name = "k_B", dscr = "Boltzmann constant k_B" },
    { t "k_B " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "sqrt", name = "Square root", dscr = "Square root" },
    { t "\\sqrt{", i(1), t "} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "grad", name = "Gradient", dscr = "Gradient" },
    { t "\\grad{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "div", name = "Divergence", dscr = "Divergence" },
    { t "\\div{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "rot", name = "Rotation", dscr = "Rotation" },
    { t "\\rot{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "lapl", name = "Laplacian", dscr = "Laplacian" },
    { t "\\lapl{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "inf", name = "Infinity", dscr = "Infinity" },
    { t "\\infty " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "inn", name = "in", dscr = "in" },
    { t "\\in " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "sr", name = "fast squared", dscr = "Fast squared exponent (², ^2)", wordTrig = false },
    { t "^2 " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "cr", name = "fast cubed", dscr = "Fast cubed exponent (³, ^3)", wordTrig = false },
    { t "^3 " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "ala", name = "a la ... (potencia)", dscr = "Potenciación (^)", wordTrig = false },
    { t "^{", i(1), t "} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "inv", name = "inverse", dscr = "Inverse", wordTrig = false },
    { t "^{-1} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "...", name = "ldots", dscr = "ldots" },
    { t "\\ldots" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "||", name = "|| mid", dscr = "|| mid", wordTrig = false },
    { t "\\mid " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "para", name = "|| parallel", dscr = "|| parallel", wordTrig = false },
    { t "\\parallel " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "perp", name = "perp", dscr = "perp", wordTrig = false },
    { t "\\perp " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "notin", name = "not in", dscr = "Not in" },
    { t "\\not\\in " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "cont", name = "subset", dscr = "Subset" },
    { t "\\subset " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "iff", name = "iff", dscr = "If and only if", priority = 90 },
    { t "\\iff " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "xx", name = "cross product", dscr = "Cross product" },
    { t "\\times " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "fa", name = "forall", dscr = "Forall" },
    { t "\\forall " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "cd", name = "cdot", dscr = "cdot", priority = 90 },
    { t "\\cdot " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "2cd", name = "cddot", dscr = "cddot", priority = 95 },
    { t "\\cddot " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "3cd", name = "cdddot", dscr = "cdddot" },
    { t "\\cdddot " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "con", name = "conjugate", dscr = "Conjugate", wordTrig = false },
    { t "^*" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "(%u)ad", name = "adjoint", dscr = "Adjoint", wordTrig = false, regTrig = true, priority = 90 },
    { f(function(_, snip)
      return snip.captures[1]
    end, {}), t "^{\\dagger} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\delta ij ", name = "Kronecker delta", dscr = "Kronecker delta", wordTrig = false },
    { t "\\delta_{ij} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "norm", name = "norm", dscr = "Norm", wordTrig = false },
    { t "\\| ", i(1), t " \\| ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "\\log 10", name = "log10", dscr = "Logarithm base 10", wordTrig = true },
    { t "\\log_{10} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "erri", name = "instrumental error", dscr = "instrumental error", wordTrig = false },
    { t "\\Delta_i ", i(1), t " ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "erra", name = "random error", dscr = "random, aleatorio, error", wordTrig = false },
    { t "\\Delta_a ", i(1), t " ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "SI", name = "SI", dscr = "SI command inside math mode", wordTrig = false },
    { t "\\SI{", i(1), t "}{", i(2), t "} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- SI units
  s(
    { trig = "nano", name = "nano", dscr = "nano", wordTrig = false },
    { t "\\nano " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "micro", name = "micro", dscr = "micro", wordTrig = false },
    { t "\\micro " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "mili", name = "mili, milli", dscr = "mili, milli", wordTrig = false },
    { t "\\milli " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "kilo", name = "kilo", dscr = "kilo", wordTrig = false },
    { t "\\kilo " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "mega", name = "mega", dscr = "mega", wordTrig = false },
    { t "\\mega " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "giga", name = "giga", dscr = "giga", wordTrig = false },
    { t "\\giga " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),

  s(
    { trig = "celsius", name = "celsius", dscr = "celsius", wordTrig = false },
    { t "\\celsius " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "ohm", name = "ohm", dscr = "ohm", wordTrig = false },
    { t "\\ohm " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "por", name = "percent, por ciento", dscr = "percent, por ciento", wordTrig = false },
    { t "\\%" },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),
  s(
    { trig = "per", name = "partido por en siunitx", dscr = "partido por en siunitx", wordTrig = false },
    { t "\\per " },
    { condition = tex.in_SI, show_condition = tex.in_SI }
  ),

  s(
    { trig = "tens", name = "Tensor", dscr = "Tensor" },
    fmt(
      [[
      \tensor<>{<>}{<>} <>
      ]],
      { i(1), i(2, "name"), i(3, "expr."), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "Tens", name = "Tensor", dscr = "Tensor" },
    fmt(
      [[
      \Tensor{<>} <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "nthis", name = "numberthis", dscr = "numberthis", wordTrig = false },
    { t "\\numberthis", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "dd", name = "dx", dscr = "Differential dx" },
    { t "\\diff " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- diff "number" --> \\diff ^{number} using function node
  s(
    { trig = "\\diff ([%d])", name = "dx", dscr = "Differential dx", regTrig = true },
    { t "\\diff^", l(l.LS_CAPTURE_1 .. " ") },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- db: "broken" differential (inexact, with a line)
  s(
    { trig = "db", name = "đx", dscr = "Inexact, broken differential đx" },
    { t "\\bdiff " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "pp", name = "partial", dscr = "Partial derivative of x" },
    { t "\\partial " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "DD", name = "d/dx", dscr = "Differential/differential d/dx" },
    fmt(
      [[
      \frac{\diff <>}{\diff <>} <>
      ]],
      { i(1), i(2), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "PP", name = "partial/partialx", dscr = "Partial/partial d/dx" },
    fmt(
      [[
      \frac{\partial <>}{\partial <>} <>
      ]],
      { i(1), i(2), i(0) },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    {
      trig = "([%d])DD",
      name = "Multiple order differential d/dx",
      dscr = "Multiple order differential d/dx",
      regTrig = true,
      priority = 200,
    },
    fmt(
      [[
    \frac{\diff^<> <>}{\diff <>} <>
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        d(2, function(_, snip, _, _)
          return sn(nil, {
            c(1, {
              t("^" .. snip.captures[1]),
              i(nil),
            }),
          })
        end),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    {
      trig = "([%d])PP",
      name = "Multiple order partial/partialx",
      dscr = "Multiple order partial/partial d/dx",
      regTrig = true,
      priority = 200,
    },
    fmt(
      [[
      \frac{\partial^<> <>}{\partial <>} <>
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        d(2, function(_, snip, _, _)
          return sn(nil, {
            c(1, {
              t("^" .. snip.captures[1]),
              i(nil),
            }),
          })
        end),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- NOTE: general rule of space skipped
  s(
    { trig = "__", name = "subscript", dscr = "subscript", wordTrig = false },
    { t "_{", i(1), t "} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- ss --> subscript
  s(
    { trig = "ss", name = "subscript", dscr = "subscript", wordTrig = false },
    { t "_{", i(1), t "}" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "sup", name = "superscript", dscr = "superscript", wordTrig = false },
    { t "^{", i(1), t "}" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s({
    trig = "([%a])(%d)",
    name = "auto subscript",
    regTrig = true,
    wordTrig = false,
  }, {
    f(function(_, snip)
      return string.format("%s_%s", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }, { condition = tex.in_mathzone }),

  s({
    trig = "([%a])_(%d%d)",
    name = "auto subscript 2",
    regTrig = true,
  }, {
    f(function(_, snip)
      return string.format("%s_{%s} ", snip.captures[1], snip.captures[2])
    end, {}),
    i(0),
  }, { condition = tex.in_mathzone }),

  -- fraction snippets
  frac,

  s(
    { trig = "//", name = "fraction", dscr = "fraction" },
    { t "\\frac{", i(1), t "}{", i(2), t "} ", i(0) },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "\\/", name = "fraction", dscr = "fraction", wordTrig = false },
    { t "/" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s({
    trig = "(\\?[%w]+\\?^%w)/",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?[%w]+\\?_%w)/",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?[%w]+\\?^{%w*})/",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?[%w]+\\?_{%w*})/",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?%w+)/",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  -- ALL FRACTIONS WITH A SPACE BEFORE TRIGGER
  s({
    trig = "(\\?[%w]+\\?^%w) /",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?[%w]+\\?_%w) /",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?[%w]+\\?^{%w*}) /",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?[%w]+\\?_{%w*}) /",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  s({
    trig = "(\\?%w+) /",
    name = "Fraction ()",
    regTrig = true,
  }, vim.deepcopy(frac_no_parens), { condition = tex.in_mathzone }),

  -- \quad, \qquad
  s(
    { trig = "quad", name = "quad", dscr = "quad" },
    { t "\\quad " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "qquad", name = "qquad", dscr = "qquad", priority = 200 },
    { t "\\qquad " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- NOTE: general rule of space skipped
  s(
    { trig = "px", name = "px", dscr = "px" },
    { t "p_x" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "py", name = "py", dscr = "py" },
    { t "p_y" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  s(
    { trig = "pz", name = "pz", dscr = "pz" },
    { t "p_z" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "([xyz])u", name = "unitary vector", dscr = "unitary vector", regTrig = true },
    { t "\\vec{\\hat{", f(function(_, snip)
      return snip.captures[1]
    end, {}), t "}} " },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  s(
    { trig = "lab", name = "label in math mode", dscr = "label in math mode" },
    { t "\\label{eq:", i(1), t "}" },
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),

  -- vector snippets
  -- s({ trig = "([%a][%a])(%.,)", regTrig = true }, vim.deepcopy(vec_node), { condition = tex.in_mathzone }),
  -- s({ trig = "([%a][%a])(,%.)", regTrig = true }, vim.deepcopy(vec_node), { condition = tex.in_mathzone }),
  -- s({ trig = "([%a])(%.,)", regTrig = true }, vim.deepcopy(vec_node), { condition = tex.in_mathzone }),
  -- s({ trig = "([%a])(,%.)", regTrig = true }, vim.deepcopy(vec_node), { condition = tex.in_mathzone }),

  -- postfix
  postfix("bar", { l("\\bar{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("gor", { l("\\hat{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("mbb", { l("\\mathbb{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("mrm", { l("\\mathrm{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("cal", { l("\\mathcal{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("bmm", { l("\\bm{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("til", { l("\\widetilde{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("ve", { l("\\vec{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix(",.", { l("\\vec{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix(".,", { l("\\vec{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),

  postfix("pun", { l("\\dot{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
  postfix("ppun", { l("\\ddot{" .. l.POSTFIX_MATCH .. "} ") }, { condition = tex.in_mathzone }),
}

-- TODO: refactor this loop
-- add greek letters to autosnips table: one snippet for each letter and one for each letter with first capital
for _, greek_letter in ipairs(greek_letters) do
  override = {
    { "epsilon", "eps" },
    { "theta", "the" },
  }
  local trig = greek_letter
  -- if greek_letter == "epsilon" then
  --   trig = "eps" -- to avoid conflict with psi
  -- end
  for _, override in ipairs(override) do
    if greek_letter == override[1] then
      trig = override[2]
    end
  end
  local name = greek_letter
  local dscr = "Greek letter " .. greek_letter
  table.insert(
    autosnips,
    s({
      trig = trig,
      name = name,
      dscr = dscr,
      wordTrig = false,
    }, { t "\\", t(name), t " " }, { condition = tex.in_mathzone })
  )
  -- capital greek letters: make capital only first letter
  trig = greek_letter:gsub("^%l", string.upper)
  name = trig
  -- if greek_letter == "epsilon" then
  --   trig = "Eps" -- to avoid conflict with psi
  -- end
  for _, override in ipairs(override) do
    if greek_letter == override[1] then
      trig = override[2]:gsub("^%l", string.upper)
    end
  end
  dscr = "Greek letter " .. trig
  table.insert(
    autosnips,
    s({
      trig = trig,
      name = name,
      dscr = dscr,
      wordTrig = false,
    }, { t "\\", t(name), t " " }, { condition = tex.in_mathzone })
  )
  -- autosubscript: greek "number" --> \\greek_number
  table.insert(
    autosnips,
    s({
      trig = "\\" .. greek_letter .. " (%d)",
      name = "auto subscript",
      regTrig = true,
      wordTrig = false,
    }, {
      t("\\" .. greek_letter),
      f(function(_, snip)
        return string.format("_%s", snip.captures[1])
      end, {}),
    }, { condition = tex.in_mathzone })
  )
  table.insert(
    autosnips,
    s({
      trig = "\\" .. greek_letter .. "_(%d%d)",
      name = "auto subscript 2",
      regTrig = true,
    }, {
      t("\\" .. greek_letter),
      f(function(_, snip)
        return string.format("_{%s} ", snip.captures[1])
      end, {}),
      t "",
    }, { condition = tex.in_mathzone })
  )

  table.insert(
    autosnips,
    s({
      trig = "\\" .. trig .. " (%d)",
      name = "auto subscript",
      regTrig = true,
    }, {
      t("\\" .. trig),
      f(function(_, snip)
        return string.format("_%s", snip.captures[1])
      end, {}),
      t "",
    }, { condition = tex.in_mathzone })
  )

  table.insert(
    autosnips,
    s({
      trig = "\\" .. trig .. "_(%d%d)",
      name = "auto subscript 2",
      regTrig = true,
    }, {
      t("\\" .. trig),
      f(function(_, snip)
        return string.format("_{%s} ", snip.captures[1])
      end, {}),
      t "",
    }, { condition = tex.in_mathzone })
  )

  -- vector: "greek " ., --> \\vec{greek}
  -- or "greek " ,. --> \\vec{greek}
  table.insert(
    autosnips,
    s({
      trig = "\\" .. greek_letter .. " (%.,)",
      name = "vector",
      regTrig = true,
    }, {
      t "\\vec{",
      t("\\" .. greek_letter),
      t "} ",
    }, { condition = tex.in_mathzone })
  )
  table.insert(
    autosnips,
    s({
      trig = "\\" .. greek_letter .. " (,%.)",
      name = "vector",
      regTrig = true,
    }, {
      t "\\vec{",
      t("\\" .. greek_letter),
      t "} ",
    }, { condition = tex.in_mathzone })
  )

  -- uppercase
  table.insert(
    autosnips,
    s({
      trig = "\\" .. trig .. " (%.,)",
      name = "vector",
      regTrig = true,
    }, {
      t "\\vec{",
      t("\\" .. trig),
      t "} ",
    }, { condition = tex.in_mathzone })
  )
  table.insert(
    autosnips,
    s({
      trig = "\\" .. trig .. " (,%.)",
      name = "vector",
      regTrig = true,
    }, {
      t "\\vec{",
      t("\\" .. trig),
      t "} ",
    }, { condition = tex.in_mathzone })
  )
end

-- for each operator in the table, add two snippets: one with its name and one with a in front of it
for _, operator in ipairs(operators) do
  local trig = operator
  local name = operator
  local dscr = "Operator " .. operator
  table.insert(
    autosnips,
    s({
      trig = trig,
      name = name,
      dscr = dscr,
    }, { t "\\", t(name), t " " }, { condition = tex.in_mathzone })
  )
  trig = "a" .. operator
  name = "arc" .. operator
  dscr = "Operator " .. trig
  table.insert(
    autosnips,
    s({
      trig = trig,
      name = name,
      dscr = dscr,
      priority = 200,
    }, { t "\\", t(name), t " " }, { condition = tex.in_mathzone })
  )
end

return snips, autosnips
