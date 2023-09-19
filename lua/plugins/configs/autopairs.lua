local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, cmp = pcall(require, "cmp")

local utils = require "core.utils"

if not (present1 and present2) then
  return
end

local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"

local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
local quotes = { '"', "`" }
local latexpairs = {
  { "\\( ", " \\)" },
  -- { "\\[", "\\]" },
  { "\\left( ", " \\right) " },
  { "\\left[ ", " \\right] " },
  { "\\left\\{ ", " \\right\\} " },
  { "\\left| ", " \\right| " },
  { "\\langle ", " \\rangle " },
  -- snippets:
  { "\\frac{\\partial ", "}{\\partial } " },
  { "\\frac{\\diff ", "}{\\diff } " },
}

autopairs.add_rules {
  Rule("`", "`"),
}

-- bracket double space
-- autopairs.add_rules {
--   Rule(" ", " "):with_pair(function(opts)
--     local pair = opts.line:sub(opts.col - 1, opts.col)
--     return vim.tbl_contains({
--       brackets[1][1] .. brackets[1][2],
--       brackets[2][1] .. brackets[2][2],
--       brackets[3][1] .. brackets[3][2],
--     }, pair)
--   end)
-- }
--
-- for _, bracket in pairs(brackets) do
--   autopairs.add_rules {
--     Rule(bracket[1] .. " ", " " .. bracket[2])
--       :with_pair(function()
--         return false
--       end)
--       :with_move(function(opts)
--         return opts.prev_char:match(".%" .. bracket[2]) ~= nil
--       end)
--       :use_key(bracket[2]),
--   }
-- end

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

-- autopairs.add_rules {
--   Rule(" ", " "):with_pair(function(opts)
--     local pair = opts.line:sub(opts.col - 1, opts.col)
--     return vim.tbl_contains({
--       quotes[1] .. quotes[1],
--       quotes[2] .. quotes[2],
--       quotes[3] .. quotes[3],
--     }, pair)
--   end),
-- }

-- latex autoremove brackets
for _, pair in pairs(latexpairs) do
  autopairs.add_rules {
    Rule(pair[1], pair[2], { "tex", "latex", "plaintex" }):with_pair(cond.none()),
  }
end
