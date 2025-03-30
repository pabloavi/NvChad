vim.bo.buflisted = true
vim.cmd "Copilot enable"

-- Make the function local
local function copilot_tab_mapping()
  if require("copilot.suggestion").is_visible() then
    -- Add pcall to handle potential errors
    local status, _ = pcall(function()
      require("copilot.suggestion").accept()
    end)
    if not status then
      return
    end
  end
  -- Fallback to regular tab if no suggestion
  return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
end

vim.keymap.set("i", "<Tab>", copilot_tab_mapping, { expr = true, silent = true })
