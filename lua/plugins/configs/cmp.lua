local cmp = require "cmp"

dofile(vim.g.base46_cache .. "cmp")

local cmp_ui = require("core.utils").load_config().ui.cmp
local cmp_style = cmp_ui.style

local field_arrangement = {
  atom = { "kind", "abbr", "menu" },
  atom_colored = { "kind", "abbr", "menu" },
}

local formatting_style = {
  -- default fields order i.e completion word + item.kind + item.kind icons
  fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

  format = function(_, item)
    local icons = require("nvchad_ui.icons").lspkind
    local icon = (cmp_ui.icons and icons[item.kind]) or ""

    if cmp_style == "atom" or cmp_style == "atom_colored" then
      icon = " " .. icon .. " "
      item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
      item.kind = icon
    else
      icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
      item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
    end

    return item
  end,
}

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local options = {
  completion = {
    completeopt = "menu,menuone",
  },

  window = {
    completion = {
      side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
      scrollbar = false,
    },
    documentation = {
      border = border "CmpDocBorder",
      winhighlight = "Normal:CmpDoc",
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = formatting_style,

  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-y>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    -- NOTE: needs callback as arg?
    ["jk"] = cmp.mapping(function()
      if require("luasnip").expand_or_jumpable() then
        -- print "hola"
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, true, true), "", true)
      end
    end, { "i", "s" }),
    ["JK"] = cmp.mapping(function()
      if require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, true, true), "", true)
      end
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "neorg" },
    { name = "omni" },
  },
}

-- show cmp even without writing anything
-- vim.api.nvim_create_autocmd("CursorHoldI", {
--   group = vim.api.nvim_create_augroup("cmp_complete_on_space", {}),
--   callback = function()
--     local line = vim.api.nvim_get_current_line()
--     local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
--     if string.sub(line, cursor, cursor + 1) == " " then
--       require("cmp").complete()
--     end
--   end,
-- })

if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
  options.window.completion.border = border "CmpBorder"
end

return options
