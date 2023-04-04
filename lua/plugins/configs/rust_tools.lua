local utils = require "core.utils"
local rust_tools = require "rust-tools"

local options = {
  tools = {
    executor = require("rust-tools.executors").termopen, -- termopen/quickfix
    inlay_hints = {
      auto = true,
      only_current_line = false,
      show_parameter_hints = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
    },
    debuggables = {
      use_telescope = true,
    },
    hover_actions = {
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },
      auto_focus = false,
    },
    crate_graph = {
      backend = "x11",
      full = true,
    },
  },
  server = {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      utils.load_mappings("lspconfig", { buffer = bufnr })

      vim.keymap.set("n", "<C-space>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rust_tools.code_action_group.code_action_group, { buffer = bufnr })

      if client.server_capabilities.signatureHelpProvider then
        require("nvchad_ui.signature").setup(client)
      end
    end,
  },
  dap = {
    adapter = {
      type = "executable",
      command = "lldb-vscode",
      name = "rt_lldb",
    },
  },
}

return options
