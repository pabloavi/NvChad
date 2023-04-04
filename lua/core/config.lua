local M = {}

M.options = {
  nvChad = {
    update_url = "https://github.com/NvChad/NvChad",
    update_branch = "v2.0",
  },
}

M.ui = {
  theme = "rosepine",
  hl_add = require("core.highlights").new_hlgroups,
  hl_override = require("core.highlights").overriden_hlgroups,
  changed_themes = {},
  theme_toggle = { "onedark", "one_light" },
  transparency = false,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "black", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = {
    style = "borderless", -- borderless / bordered
  },

  statusline = {
    theme = "minimal", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "block",
    overriden_modules = nil,
    -- function()
    --   local st_modules = require "nvchad_ui.statusline.default"
    --   local wpm = require "wpm"
    --   -- this is just default table of statusline modules
    --   return {
    --     fileInfo = function()
    --       return st_modules.fileInfo() .. "%#St_pos_text#" .. "WPM " .. wpm.wpm() .. " "
    --     end,
    --   }
    -- end,
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    show_numbers = false,
    enabled = true,
    lazyload = true,
    overriden_modules = function()
      return {
        buttons = function()
          return "%@TbCloseAllBufs@%#TbLineCloseAllBufsBtn#" .. "  " .. "%X"
        end,
      }
    end,
  },

  -- nvdash (dashboard)
  nvdash = {
    load_on_startup = false,

    header = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    },

    buttons = {
      { "  Find File", "Space f f", "Telescope find_files" },
      { "  Recent Files", "Space f o", "Telescope oldfiles" },
      { "  Find Word", "Space f w", "Telescope live_grep" },
      { "  Bookmarks", "Space b m", "Telescope marks" },
      { "  Themes", "Space t h", "Telescope themes" },
      { "  Mappings", "Space c h", "NvCheatsheet" },
    },
  },

  cheatsheet = {
    theme = "simple", -- simple/grid
  },

  lsp = {
    -- show function signatures i.e args as you type
    signature = {
      disabled = false,
      silent = true, -- silences 'no signature help available' message from appearing
    },
  },
}

M.lazy_nvim = require "plugins.configs.lazy_nvim" -- config for lazy.nvim startup options

-- these are default mappings, check core.mappings for table structure
M.mappings = require "core.mappings"

return M
