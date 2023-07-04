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

-- get following neovim lines from the current line given number of lines
-- current line is included
-- example: print_lines(get_lines(3))
local function get_lines(num_lines)
  local lines = vim.api.nvim_buf_get_lines(
    0,
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1] - 1 + num_lines,
    true
  )
  return lines -- table
end

local function set_lines(num_lines, lines)
  vim.api.nvim_buf_set_lines(
    0,
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1] - 1 + num_lines,
    false,
    lines
  )
end

snips = {

  -- counters
  -- eq-1

  -- s("eq", {
  --   m(1, "^$", "\\begin{equation*}", "\\begin{equation}\\label{eq:"),
  --   i(1),
  --   n(1, "}"),
  --   t { "", "\t" },
  --   i(2),
  --   m(1, "^$", "\n.\\end{equation*}\n", "\n.\\end{equation}\n"),
  --   i(0),
  -- }, { condition = tex.in_text, show_condition = tex.in_text }),
}

autosnips = {
  s(
    { trig = "([%d])dm", name = "Super display math", dscr = "Super display math mode", regTrig = true },
    fmt(
      [[
      \[
      <>
      <>\]

      <>
      ]],
      {
        f(function(_, snip)
          local row = vim.api.nvim_win_get_cursor(0)[1]
          -- -- prevent index error
          -- if row + tonumber(snip.captures[1]) > vim.api.nvim_buf_line_count(0) - 1 then
          --   print "Ha superado el número de líneas máximo"
          --   return
          -- end
          local lines = vim.api.nvim_buf_get_lines(0, row, row + tonumber(snip.captures[1]), true)
          local current_line = vim.api.nvim_get_current_line()
          if current_line ~= "" then
            -- line - 1
            local lines_1 = vim.api.nvim_buf_get_lines(0, row - 1, row + tonumber(snip.captures[1]) - 1, true)
            vim.api.nvim_buf_set_lines(0, row - 1, row + tonumber(snip.captures[1] - 1), false, { "" })
            return lines_1
          else
            vim.api.nvim_buf_set_lines(0, row, row + tonumber(snip.captures[1]), false, { "" })
            return lines
          end
        end),
        c(1, { t ".", t ",", t "" }),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text * expand.line_begin }
  ),

  s(
    { trig = "([%d])ali", name = "Super align", dscr = "Super align", regTrig = true },
    fmt(
      [[
      \begin{align}
      <>
      <>\end{align}

      <>
      ]],
      {
        f(function(_, snip)
          local current_line = vim.api.nvim_get_current_line()
          local current_line_number = vim.api.nvim_win_get_cursor(0)[1]
          local lines_to_edit = tonumber(snip.captures[1])
          if current_line == "" then
            local lines = get_lines(lines_to_edit)
            set_lines { lines_to_edit, { "" } }
            return lines
          else
            local lines = get_lines(tonumber(snip.captures[1]) + 1)
            lines = table.remove(lines, 1)
            return lines
          end
        end),
        c(1, { t ".", t ",", t "" }),
        i(0),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text * expand.line_begin }
  ),
  -- s({
  --   trig = "([a-zA-Z])bf",
  --   name = "math bold",
  --   wordTrig = false,
  --   regTrig = true,
  -- }, {
  --   f(function(_, snip)
  --     return "\\mathbf{" .. snip.captures[1] .. "}"
  --   end, {}),
  -- }, { condition = tex.in_mathzone }),

  -- TODO: make space as exit for m(...)
  s(
    { trig = "pd", name = "Super partial derivative", dscr = "Super partial/partial" },
    fmt(
      [[
      <>
      ]],
      {
        c(1, {
          sn(nil, {
            t "\\left( ",
            t "\\frac{\\partial ",
            i(1),
            t "}{\\partial ",
            i(2),
            t "} \\right)",
            m(3, "^$", "", "_{"),
            i(3),
            m(3, "^$", " ", "} "),
            i(0),
          }),
          sn(nil, {
            t "\\left[ ",
            t "\\frac{\\partial ",
            i(1),
            t "}{\\partial ",
            i(2),
            t "} \\right]",
            m(3, "^$", "", "_{"),
            i(3),
            m(3, "^$", " ", "} "),
            i(0),
          }),
          sn(nil, {
            t "\\left{ ",
            t "\\frac{\\partial ",
            i(1),
            t "}{\\partial ",
            i(2),
            t "} \\right}",
            m(3, "^$", "", "_{"),
            i(3),
            m(3, "^$", " ", "} "),
            i(0),
          }),
        }),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  ),
  -- s(
  --   {
  --     trig = "([%d])DD([%a])",
  --     name = "d/dx order",
  --     dscr = "Multiple order differential/differential d/dx",
  --     regTrig = true,
  --   },
  --   fmt(
  --     [[
  --     \frac{\diff<> <>}{\diff <><>} <><><><>
  --     ]],
  --     {
  --       f(function(_, snip)
  --         return "^" .. snip.captures[1]
  --       end, {}),
  --       i(1),
  --       i(2),
  --       f(function(_, snip)
  --         return "^" .. snip.captures[1]
  --       end, {}),
  --       f(function(_, snip)
  --         if snip.captures[2] == "p" then
  --           return "\\left( "
  --         elseif snip.captures[2] == "b" then
  --           return "\\left[ "
  --         elseif snip.captures[2] == "c" then
  --           return "\\left{ "
  --         else
  --           return ""
  --         end
  --       end, {}),
  --       i(3),
  --       f(function(_, snip)
  --         if snip.captures[2] == "p" then
  --           return " \\right) "
  --         elseif snip.captures[2] == "b" then
  --           return " \\right] "
  --         elseif snip.captures[2] == "c" then
  --           return " \\right} "
  --         else
  --           return ""
  --         end
  --       end, {}),
  --       i(0),
  --     },
  --     { delimiters = "<>" }
  --   ),
  --   { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  -- ),
  --
  -- s(
  --   {
  --     trig = "([%d])PP([%a])",
  --     name = "partial/partialx order",
  --     dscr = "Multiple order partial/partial d/dx",
  --     regTrig = true,
  --   },
  --   fmt(
  --     [[
  --     \frac{\partial<> <>}{\partial <><>} <><><><>
  --     ]],
  --     {
  --       f(function(_, snip)
  --         return "^" .. snip.captures[1]
  --       end, {}),
  --       i(1),
  --       i(2),
  --       f(function(_, snip)
  --         return "^" .. snip.captures[1]
  --       end, {}),
  --       f(function(_, snip)
  --         if snip.captures[2] == "p" then
  --           return "\\left( "
  --         elseif snip.captures[2] == "b" then
  --           return "\\left[ "
  --         elseif snip.captures[2] == "c" then
  --           return "\\left{ "
  --         else
  --           return ""
  --         end
  --       end, {}),
  --       i(3),
  --       f(function(_, snip)
  --         if snip.captures[2] == "p" then
  --           return " \\right) "
  --         elseif snip.captures[2] == "b" then
  --           return " \\right] "
  --         elseif snip.captures[2] == "c" then
  --           return " \\right} "
  --         else
  --           return ""
  --         end
  --       end, {}),
  --       i(0),
  --     },
  --     { delimiters = "<>" }
  --   ),
  --   { condition = tex.in_mathzone, show_condition = tex.in_mathzone }
  -- ),

  -- enumerate begining is the trigger
  s(
    { trig = "\\begin{enumerate}a", name = "enumerate", dscr = "enumerate" },
    fmt(
      [[
      \begin{enumerate}{label=<>}
      ]],
      {
        c(1, { t "\\alph*.", t "\\roman*.", t "\\arabic*." }),
      },
      { delimiters = "<>" }
    ),
    { condition = tex.in_text * expand.line_begin, show_condition = tex.in_text * expand.line_begin }
  ),
}

return snips, autosnips
