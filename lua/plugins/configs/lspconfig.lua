local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

dofile(vim.g.base46_cache .. "lsp")
require "nvchad_ui.lsp"

local M = {}
local utils = require "core.utils"
local lsp_utils = require "plugins.configs.utils.lsp"

local servers = { -- lua_ls is configured appart
  "pyright",
  "texlab",
  "ltex",
  "yamlls",
  "bashls",
  "vimls",
  "fortls",
  "marksman",
  -- "rust_analyzer",
  -- "html",
  -- "cssls",
  -- "clangd",
  -- "jdtls",
  -- "eslint",
}

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end
  -- TODO: only attach if client supports it
  require("nvim-navbuddy").attach(client, bufnr)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  }
end

if lsp_utils.in_table("ltex", servers) then
  lspconfig["ltex"].setup {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      require("ltex_extra").setup {
        load_langs = { "es", "en" }, -- languages for witch dictionaries will be loaded
        init_check = true, -- load dictionaries on startup
        path = nil, -- where to store dictionaries. relative = from cwd
        log_level = "none",
      }
    end,
    settings = {
      ["ltex"] = {
        enabled = true,
        language = "es",
        checkFrequency = "save", -- edit, save, manual
      },
    },
  }
end

-- texlab config
if lsp_utils.in_table("texlab", servers) then
  lspconfig["texlab"].setup {
    settings = {
      texlab = {
        auxDirectory = ".",
        bibtexFormatter = "texlab",
        build = {
          -- args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", get_main_file() },
          args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%p" },
          executable = "latexmk",
          forwardSearchAfter = false,
          onSave = false, -- now using vimtex
        },
        chktex = {
          onEdit = false,
          onOpenAndSave = true,
        },
        diagnosticsDelay = 30,
        formatterLineLength = 80,
        forwardSearch = {
          executable = "zathura",
          -- TODO: add pdf file detection
          args = { "--synctex-forward", "%l:1:%f", "%p" },
          onSave = false, -- now using vimtex
        },
        latexFormatter = "latexindent",
        latexindent = {
          modifyLineBreaks = true,
        },
      },
    },
  }
end

return M
