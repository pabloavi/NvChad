local has_native_lsp_config = vim.fn.has "nvim-0.11" == 1
  and vim.lsp
  and vim.lsp.config ~= nil
  and type(vim.lsp.enable) == "function"
local lspconfig

if not has_native_lsp_config then
  local present
  present, lspconfig = pcall(require, "lspconfig")

  if not present then
    return
  end
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
  "eslint",
  "yamlls",
  "bashls",
  "vimls",
  "fortls",
  "marksman",
  "verible",
  "arduino_language_server",
  "nil_ls",
  "clangd", -- FIXME: should be places appart
}

if vim.g.java_enabled then
  table.insert(servers, "jdtls")
end

if vim.g.webdev_enabled then
  vim.list_extend(servers, { "html", "cssls" })
end

local function setup_server(server_name, opts)
  opts = opts or {}

  if has_native_lsp_config then
    local ok_config = pcall(function()
      vim.lsp.config(server_name, opts)
    end)
    if not ok_config then
      vim.schedule(function()
        vim.notify("Failed to configure LSP server: " .. server_name, vim.log.levels.WARN)
      end)
      return
    end

    local ok_enable = pcall(vim.lsp.enable, server_name)
    if not ok_enable then
      vim.schedule(function()
        vim.notify("Failed to enable LSP server: " .. server_name, vim.log.levels.WARN)
      end)
    end

    return
  end

  lspconfig[server_name].setup(opts)
end

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end

  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint.enable(true)
  -- end
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
  setup_server("clangd", {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      require("nvim-navbuddy").attach(client, bufnr)
    end,
    capabilities = M.capabilities,
    cmd = {
      "clangd",
      "--offset-encoding=utf-16",
    },
  })
end

local configured_servers = {}
for _, lsp in ipairs(servers) do
  if type(lsp) == "string" and not configured_servers[lsp] then
    configured_servers[lsp] = true

    setup_server(lsp, {
      on_attach = function(client, bufnr)
        M.on_attach(client, bufnr)
        require("nvim-navbuddy").attach(client, bufnr)
      end,
      capabilities = M.capabilities,
    })
  end
end

setup_server("lua_ls", {
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
})

-- if vim.g.ltex_enabled then
--   lspconfig["ltex"].setup {
--     on_attach = function(client, bufnr)
--       M.on_attach(client, bufnr)
--       require("ltex_extra").setup {
--         load_langs = "es", -- languages for witch dictionaries will be loaded
--         init_check = true, -- load dictionaries on startup
--         path = vim.fn.stdpath "config" .. "/spell", -- where to store dictionaries. relative = from cwd
--         log_level = "none",
--         server_opts = {
--
--         }
--       }
--     end,
--     settings = {
--       ["ltex"] = {
--         enabled = true,
--         language = "es",
--         checkFrequency = "save", -- edit, save, manual
--       },
--     },
--   }
-- end
-- texlab config
setup_server("texlab", {
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
})

-- typst
setup_server("tinymist", {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    require("nvim-navbuddy").attach(client, bufnr)
  end,
  capabilities = M.capabilities,
  settings = {
    exportPdf = "never", -- onType, onSave or never.
  },
})

return M
