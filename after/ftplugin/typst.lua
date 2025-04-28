require("core.utils").load_mappings "typst"

vim.opt_local.spelllang = "es"
vim.opt_local.conceallevel = 0
vim.opt_local.spell = true

-- vim.g.typst_pdf_viewer = "sioyek"
vim.g.typst_conceal_math = false
vim.g.typst_no_editor = true -- custom: don't open editor

vim.cmd "set backupcopy=yes" -- so that typst watch doesnt fail on save

-- local _, bufname = pcall(vim.api.nvim_buf_get_name, 0)
-- local names = {
--   "master.typ",
--   "main.typ",
-- }
--
-- for _, name in ipairs(names) do
--   if vim.endswith(bufname, name) then
--     vim.cmd "silent! TypstWatch"
--   end
-- end

local present, surround = pcall(require, "nvim-surround")

if not present then
  return
end

surround.buffer_setup {
  -- Configuration here, or leave empty to use defaults
  surrounds = {
    ["*"] = {
      -- Define how asterisks are added (for emphasis in Typst)
      add = function()
        return { { "*" }, { "*" } }
      end,
      -- Find text surrounded by asterisks
      find = function()
        local config = require "nvim-surround.config"
        return config.get_selection { pattern = "%*(.-)%*" }
      end,
      -- Delete asterisk surrounds
      delete = function()
        local config = require "nvim-surround.config"
        return config.get_selections {
          char = "*",
          pattern = "^(%*)().-(%*)()$",
        }
      end,
      -- Change asterisk surrounds to something else
      change = {
        target = function()
          local config = require "nvim-surround.config"
          return config.get_selections {
            char = "*",
            pattern = "^(%*)().-(%*)()$",
          }
        end,
      },
    },
  },
  ["_"] = {
    -- Define how underscores are added (for emphasis in Typst)
    add = function()
      return { { "_" }, { "_" } }
    end,
    -- Find text surrounded by underscores
    find = function()
      local config = require "nvim-surround.config"
      return config.get_selection { pattern = "%_(.-)%_" }
    end,
    -- Delete underscore surrounds
    delete = function()
      local config = require "nvim-surround.config"
      return config.get_selections {
        char = "_",
        pattern = "^(%_)().-(%_)()$",
      }
    end,
    -- Change underscore surrounds to something else
    change = {
      target = function()
        local config = require "nvim-surround.config"
        return config.get_selections {
          char = "_",
          pattern = "^(%_)().-(%_)()$",
        }
      end,
    },
  },
}
