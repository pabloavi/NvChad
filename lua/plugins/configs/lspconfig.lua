local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

dofile(vim.g.base46_cache .. "lsp")
require "nvchad_ui.lsp"

local M = {}
local utils = require "core.utils"
local lsp_utils = require "plugins.configs.utils.lsp"

local servers = { -- lua_ls, texlab, ltex and clangd are configured appart
  "pyright",
  -- "texlab",
  -- "ltex",
  "yamlls",
  "bashls",
  "vimls",
  "fortls",
  "marksman",
}

if vim.g.java_enabled then
  table.insert(servers, "jdtls")
end

if vim.g.webdev_enabled then
  table.insert(servers, { "html", "cssls", "eslint" })
end

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end
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

if vim.g.c_enabled then
  lspconfig["clangd"].setup {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      require("nvim-navbuddy").attach(client, bufnr)
    end,
    capabilities = function()
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
      }
    end,
  }
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      require("nvim-navbuddy").attach(client, bufnr)
    end,
    capabilities = M.capabilities,
  }
end

lspconfig.lua_ls.setup {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    require("nvim-navbuddy").attach(client, bufnr)
  end,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "awesome", "client", "screen" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          -- "/usr/share/awesome/lib",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

if vim.g.ltex_enabled then
  lspconfig["ltex"].setup {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      require("ltex_extra").setup {
        load_langs = { "es", "en" }, -- languages for witch dictionaries will be loaded
        init_check = true, -- load dictionaries on startup
        path = vim.fn.stdpath "config" .. "/spell", -- where to store dictionaries. relative = from cwd
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
lspconfig["texlab"].setup {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    require("nvim-navbuddy").attach(client, bufnr)
  end,
  capabilities = M.capabilities,
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        -- args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", get_main_file() },
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = false, -- now using vimtex
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = true,
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        executable = "zathura",
        args = {
          "--synctex-editor-command",
          [[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
          "--synctex-forward",
          "%l:1:%f",
          "%p",
        },
        onSave = false, -- now using vimtex
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = true,
      },
    },
  },
}

return M
