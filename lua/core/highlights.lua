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

  -- typst
  ["@lsp.type.pol.typst"] = { link = "@identifier" },

  ["@lsp.type.string.typst"] = { link = "@string" },
  ["@lsp.type.bool.typst"] = { link = "@boolean" },
  ["@lsp.type.number.typst"] = { link = "@number" },
  ["@lsp.type.float.typst"] = { link = "@float" },
  ["@lsp.type.keyword.typst"] = { link = "@keyword" },
  ["@lsp.type.operator.typst"] = { link = "@operator" },
  ["@lsp.type.label.typst"] = { link = "@label" },
  ["@lsp.type.marker.typst"] = { link = "@structure" },
  ["@lsp.type.delim.typst"] = { link = "@delimiter" },

  ["@lsp.type.heading.typst"] = { bold = true, underline = true },

  ["@lsp.mod.emph.typst"] = { italic = true },
  ["@lsp.mod.strong.typst"] = { bold = true },
  -- ["@lsp.mod.math.typst"] = {},

  ["@lsp.typemod.delim.math.typst"] = { fg = "yellow" },
}

M.overriden_hlgroups = {
  AlphaHeader = { fg = "blue" },
}

return M
