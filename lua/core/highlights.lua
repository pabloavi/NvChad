local M = {}

M.new_hlgroups = {

  -- comment = { fg = "grey_fg2" },

  FoldColumn = { fg = "grey", bg = "black" },
  UfoFoldedBg = { fg = "grey", bg = "black" }, -- fix the flicker

  -- illuminatedWord = { bg = "white" },
  -- IlluminatedWordText = { link = "Visual" },
  -- IlluminatedWordRead = { link = "Visual" },
  -- IlluminatedWordWrite = { link = "Visual" },
  IlluminatedWordText = { bg = "one_bg3" },
  IlluminatedWordRead = { bg = "one_bg3" },
  IlluminatedWordWrite = { bg = "one_bg3" },

  -- Neorg
  NeorgCodeBlock = { bg = "black2" },
  NeorgUnorderedList1 = { fg = "grey_fg" },
  NeorgUnorderedList2 = { fg = "grey_fg" },
  NeorgUnorderedList3 = { fg = "grey_fg" },
  NeorgUnorderedList4 = { fg = "grey_fg" },
  NeorgUnorderedList5 = { fg = "grey_fg" },
  NeorgUnorderedList6 = { fg = "grey_fg" },
  NeorgHeading1Title = { fg = "white", bold = true },
  NeorgHeading1Prefix = { fg = "white", bold = true },
  NeorgHeading2Title = { fg = "red", bold = true },
  NeorgHeading2Prefix = { fg = "red", bold = true },
  NeorgHeading3Title = { fg = "green", bold = true },
  NeorgHeading3Prefix = { fg = "green", bold = true },
  NeorgHeading4Title = { fg = "blue", bold = true },
  NeorgHeading4Prefix = { fg = "blue", bold = true },
  NeorgHeading5Title = { fg = "purple", bold = true },
  NeorgHeading5Prefix = { fg = "purple", bold = true },
  NeorgHeading6Title = { fg = "yellow", bold = true },
  NeorgHeading6Prefix = { fg = "yellow", bold = true },
  NeorgMarkUpBold = { fg = "red", bold = true },
  FakeLineNr = { fg = "black", bg = "black" },

  -- Noice
  NoiceCmdline = { bg = "darker_black" },
  NoiceCmdlinePopup = { bg = "darker_black" },
  NoiceCmdlinePopupBorderHelp = { bg = "darker_black" },
  NoiceCmdlinePopupBorderCmdline = { bg = "darker_black" },
  NoiceCmdlinePopupBorderFilter = { bg = "darker_black" },
  NoiceCmdlinePopupBorderInput = { bg = "darker_black" },
  NoiceCmdlinePopupBorderLua = { bg = "darker_black" },
  NoiceCmdlinePopupBorderSearch = { bg = "darker_black" },
  NoiceLspProgressClient = { bg = "black", fg = "light_grey" },
  NoiceLspProgressSpinner = { bg = "darker_black" },
  NoiceLspProgressTitle = { bg = "black", fg = "white" },
  NoiceMini = { bg = "dark_black", fg = "white" },
  NoiceCmdlineIcon = { bg = "darker_black", fg = "light_bg", bold = true },

  -- NVIM NOTIFY
  NotifyERRORBorder = { bg = "darker_black", fg = "darker_black" },
  NotifyWARNBorder = { bg = "darker_black", fg = "darker_black" },
  NotifyINFOBorder = { bg = "darker_black", fg = "darker_black" },
  NotifyDEBUGBorder = { bg = "darker_black", fg = "darker_black" },
  NotifyTRACEBorder = { bg = "darker_black", fg = "darker_black" },

  NotifyERRORBody = { bg = "darker_black", fg = "white" },
  NotifyWARNBody = { bg = "darker_black", fg = "white" },
  NotifyINFOBody = { bg = "darker_black", fg = "white" },
  NotifyDEBUGBody = { bg = "darker_black", fg = "white" },
  NotifyTRACEBody = { bg = "darker_black", fg = "white" },
}

M.overriden_hlgroups = {
  AlphaHeader = { fg = "blue" },
}

return M
