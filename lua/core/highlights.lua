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
  ["@variable.typst"] = { link = "@lsp.type.pol.typst" },

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

  -- ts
  ["@constant.numeric.typst"] = { link = "@lsp.type.number.typst" },

  -- gitsigns
  ["GitSignsAdd"] = { link = "DiffAdd" },
  ["GitSignsAddNr"] = { link = "GitSignsAddNr" },
  ["GitSignsChange"] = { link = "DiffChange" },
  ["GitSignsChangeNr"] = { link = "GitSignsChangeNr" },
  ["GitSignsDelete"] = { link = "DiffDelete" },
  ["GitSignsDeleteNr"] = { link = "GitSignsDeleteNr" },
  ["GitSignsTopDelete"] = { link = "DiffDelete" },
  ["GitSignsTopDeleteNr"] = { link = "GitSignsDeleteNr" },
  ["GitSignsChangeDelete"] = { link = "DiffChangeDelete" },
  ["GitSignsChangeDeleteNr"] = { link = "GitSignsChangeNr" },
  ["GitSignsUntracked"] = { link = "GitSignsAdd" },
  ["GitSignsUntrackedNr"] = { link = "GitSignsAddNr" },
  ["GitSignsUntrackedLn"] = { link = "GitSignsAddLn" },

  -- ["@markup.raw.block"] = { bg = "darker_black" },

  -- render-markdown.nvim
  ["@markup.heading"] = { bold = true, fg = "#ef596f" },
  ["@markup.heading.1.markdown"] = { bold = true, fg = "#ef596f" },
  ["@markup.heading.2.markdown"] = { bold = true, fg = "#ffc777" },
  ["@markup.heading.3.markdown"] = { bold = true, fg = "#c3e88d" },
  ["@markup.heading.4.markdown"] = { bold = true, fg = "#4fd6be" },
  ["@markup.heading.5.markdown"] = { bold = true, fg = "#c099ff" },
  ["@markup.heading.6.markdown"] = { bold = true, fg = "#fca7ea" },
  ["@markup.link.label.markdown_inline"] = { fg = "#82aaff" },
  RenderMarkdownDash = { fg = "#ff966c" },
  RenderMarkdownH1Bg = { bg = "#593838" },
  RenderMarkdownH1Fg = { bold = true, fg = "#ef596f" },
  RenderMarkdownH2Bg = { bg = "#4f452f" },
  RenderMarkdownH2Fg = { bold = true, fg = "#ffc777" },
  RenderMarkdownH3Bg = { bg = "#404f2f" },
  RenderMarkdownH3Fg = { bold = true, fg = "#c3e88d" },
  RenderMarkdownH4Bg = { bg = "#34494a" },
  RenderMarkdownH4Fg = { bold = true, fg = "#4fd6be" },
  RenderMarkdownH5Bg = { bg = "#47344a" },
  RenderMarkdownH5Fg = { bold = true, fg = "#c099ff" },
  RenderMarkdownH6Bg = { bg = "#5c4254" },
  RenderMarkdownH6Fg = { bold = true, fg = "#fca7ea" },
  RenderMarkdownTableHead = { fg = "#ff757f" },
  RenderMarkdownTableRow = { fg = "#ff966c" },
  DiagnosticError = { fg = "#c53b53" },
  DiagnosticHint = { fg = "#4fd6be" },
  DiagnosticInfo = { fg = "#0db9d7" },
  DiagnosticWarn = { fg = "#ffc777" },
}

M.overriden_hlgroups = {
  AlphaHeader = { fg = "blue" },
}

return M
