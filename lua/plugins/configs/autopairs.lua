local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, cmp = pcall(require, "cmp")

local utils = require "core.utils"

if not (present1 and present2) then
  return
end

local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"

autopairs.remove_rule "'"

local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
local quotes = { '"', "`" }
local latexpairs = {
  { "\\( ", " \\)" },
  { "\\( ", " \\)" },
  { "\\{", "\\}" },
  -- { "\\[", "\\]" },
  { "\\left( ", " \\right) " },
  { "\\left[ ", " \\right] " },
  { "\\left\\{ ", " \\right\\} " },
  { "\\left| ", " \\right| " },
  { "\\langle ", " \\rangle " },
  -- snippets:
  { "\\frac{\\partial ", "}{\\partial } " },
  { "\\frac{\\diff ", "}{\\diff } " },
  -- { "\\textbf{", "\\}" },
  -- { "\\textit{", "\\}" },
  -- { "\\texttt{", "\\}" },
}

autopairs.add_rules {
  Rule("`", "`"),
}

-- nvim autopairs + luasnip
for _, bracket in pairs(brackets) do
  autopairs
    .get_rule(bracket[1])
    :replace_endpair(function()
      return '<cmd>lua require"luasnip".expand_or_jump()<Cr>'
    end)
    :set_end_pair_length(0)
end

autopairs.add_rules {
  Rule("¿", "?"):replace_endpair(function()
    return '<cmd>lua require"luasnip".expand_or_jump()<Cr>'
  end):set_end_pair_length(0),
}

for _, quote in pairs(quotes) do
  autopairs
    .get_rule(quote)[1]
    :replace_endpair(function()
      return '<cmd>lua require"luasnip".expand_or_jump()<Cr>'
    end)
    :set_end_pair_length(0)
end

-- latex autoremove brackets
for _, pair in pairs(latexpairs) do
  autopairs.add_rules {
    Rule(pair[1], pair[2], { "tex", "latex", "plaintex" }):with_pair(cond.none()),
  }
end

-- ADD SPACES BETWEEN PARENTHESES
autopairs.add_rules {
  -- Rule for a pair with left-side ' ' and right side ' '
  Rule(" ", " ")
    -- Pair will only occur if the conditional function returns true
    :with_pair(function(opts)
      -- We are checking if we are inserting a space in (), [], or {}
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2],
      }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({
        brackets[1][1] .. "  " .. brackets[1][2],
        brackets[2][1] .. "  " .. brackets[2][2],
        brackets[3][1] .. "  " .. brackets[3][2],
      }, context)
    end),
}
-- For each pair of brackets we will add another rule
for _, bracket in pairs(brackets) do
  autopairs.add_rules {
    -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
    Rule(bracket[1] .. " ", " " .. bracket[2])
      :with_pair(cond.none())
      :with_move(function(opts)
        return opts.char == bracket[2]
      end)
      :with_del(cond.none())
      :use_key(bracket[2])
      -- Removes the trailing whitespace that can occur without this
      :replace_map_cr(function(_)
        return "<C-c>2xi<CR><C-c>O"
      end),
  }
end

-- TYPST
local typst_pairs = {
  { "$", "$" },
  { "*", "*" },
  { "_", "_" },
}
for _, pair in pairs(typst_pairs) do
  autopairs.add_rules {
    Rule(pair[1], pair[2], { "typst" }):with_pair(cond.none()),
  }
end

-- autopairs.add_rules {
--   Rule(" ", " ", { "typst" }):with_pair(function(opts)
--     local pair = opts.line:sub(opts.col - 1, opts.col)
--     return vim.tbl_contains({
--       "$" .. "$",
--     }, pair)
--   end),
-- }

autopairs
  .get_rule("$")
  :replace_endpair(function()
    return '<cmd>lua require"luasnip".expand_or_jump()<Cr>'
  end)
  :set_end_pair_length(0)

autopairs.add_rules {
  -- Rule for a pair with left-side ' ' and right side ' '
  Rule(" ", " ", { "typst" })
    -- Pair will only occur if the conditional function returns true
    :with_pair(function(opts)
      -- We are checking if we are inserting a space in (), [], or {}
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        "$" .. "$",
      }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({
        "$" .. "  " .. "$",
      }, context)
    end),
}
-- For each pair of brackets we will add another rule
autopairs.add_rules {
  -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
  Rule("$" .. " ", " " .. "$")
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == "$"
    end)
    :with_del(cond.none())
    :use_key("$")
    -- Removes the trailing whitespace that can occur without this
    :replace_map_cr(function(_)
      return "<C-c>2xi<CR><C-c>O"
    end),
}
