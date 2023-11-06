local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local latexindent_file = vim.fn.stdpath "config" .. "/latexindent.yaml"

local b = null_ls.builtins

local sources = {
  b.formatting.stylua,
  b.formatting.yamlfmt,
  b.formatting.black, -- python
  b.formatting.shfmt,
  b.formatting.fprettify, -- installed through pip
  b.formatting.rustfmt,
  b.formatting.markdownlint,
  b.formatting.prettierd.with { filetypes = { "html", "css", "javascript", "json" } },

  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  b.diagnostics.jsonlint,

  b.formatting.latexindent.with { args = { "-c=/tmp/", "-m", "-r", "-l=" .. latexindent_file, "-" } }, -- installed through texlive, now using texlab
  b.formatting.bibclean, -- installed through pacman

  b.formatting.verible_verilog_format,
  -- b.diagnostics.chktex, -- installed through texlive, now using texlab
  b.formatting.verible_verilog_format,
  b.formatting.astyle, -- installed through pacman
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
