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
}

M.overriden_hlgroups = {
  AlphaHeader = { fg = "blue" },
}

return M
