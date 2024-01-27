---@type Base64HLGroupList
local M = {}

M.new_hlgroups = {
  -- vim
  Folded = { fg = "grey", bg = "black" },
  -- nvim ufo
  FoldColumn = { fg = "grey", bg = "black" },
  UfoFoldedBg = { fg = "grey", bg = "black" }, -- fix the flicker

  -- illuminate (highlight the word under cursor)
  IlluminatedWordText = { bg = "one_bg3" },
  IlluminatedWordRead = { bg = "one_bg3" },
  IlluminatedWordWrite = { bg = "one_bg3" },

  -- latex
  -- NOTE: maybe just italic = true instead of link
  ["@text.environment.latex"] = { fg = "red" },
  ["@text.environment.name.latex"] = { fg = "yellow" },
  ["@text.emphasis.latex"] = { link = "italic" },

  -- typst
  ["@lsp.type.pol.typst"] = { fg = "pink" },

  ["@lsp.type.string.typst"] = { link = "@string" },
  ["@lsp.type.bool.typst"] = { link = "@boolean" },
  ["@lsp.type.number.typst"] = { link = "@number" },
  ["@lsp.type.float.typst"] = { link = "@float" },
  ["@lsp.type.keyword.typst"] = { link = "@keyword" },
  ["@lsp.type.label.typst"] = { link = "@label" },
  ["@lsp.type.marker.typst"] = { link = "@structure" },
  ["@lsp.type.delim.typst"] = { link = "@delimiter" },

  ["@lsp.type.heading.typst"] = { bold = true, underline = true },

  ["@lsp.mod.emph.typst"] = { italic = true },
  ["@lsp.mod.strong.typst"] = { bold = true },
  -- ["@lsp.mod.math.typst"] = {},

  ["@lsp.typemod.delim.math.typst"] = { fg = "yellow" },
  ["@lsp.type.operator.typst"] = { fg = "red" },
  ["@lsp.type.escape.typst"] = { link = "@lsp.type.operator.typst" },
  ["@lsp.type.ref.typst"] = { link = "@keyword" },
}

M.overriden_hlgroups = {
  AlphaHeader = { fg = "blue" },
}

return M
