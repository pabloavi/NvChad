local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  b.formatting.stylua,

  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  b.formatting.prettierd.with { filetypes = { "html", "css", "javascript", "json" } },

  b.formatting.yamlfmt,

  b.formatting.markdownlint,

  b.formatting.black, -- python

  b.formatting.fprettify, -- installed through pip

  -- b.formatting.latexindent, -- installed through texlive, now using texlab
  -- b.diagnostics.chktex, -- installed through texlive, now using texlab

  b.formatting.rustfmt,
}

if vim.g.c_enabled or vim.g.java_enabled then
  table.insert(sources, b.formatting.clang_format)
end

if vim.g.webdev_enabled then
  local add = {
    b.diagnostics.eslint_d,
  }
  table.insert(sources, add)
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup {
  debug = false,
  sources = sources,
  -- format on save
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
