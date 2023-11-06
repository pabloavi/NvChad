local options = {
  ensure_installed = {
    -- lua
    "lua-language-server",
    "stylua",
    -- -- python
    "pylyzer",
    "black",
    "debugpy",
    -- latex
    "texlab",
    -- yaml
    "yaml-language-server",
    "yamlfmt",
    --bash
    "bash-language-server",
    "shfmt",
    -- vim
    "vim-language-server",
    -- fortran
    "fortls",
    -- markdown
    "marksman",
    "markdownlint",
    -- rust
    "rust-analyzer",
    "rustfmt",
    -- json
    "jsonlint",
    --arduino
    "arduino-language-server",
  },

  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ﮊ",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

if vim.g.c_enabled then
  for _, element in ipairs { "clangd", "clang-format" } do
    table.insert(options.ensure_installed, element)
  end
end

if vim.g.java_enabled then
  for _, element in ipairs { "clangd", "jdtls" } do
    table.insert(options.ensure_installed, element)
  end
end

if vim.g.webdev_enabled then
  for _, element in ipairs { "html-lsp", "css-lsp", "prettierd", "eslint-lsp", "eslint_d" } do
    table.insert(options.ensure_installed, element)
  end
end

if vim.g.ltex_enabled then
  table.insert(options.ensure_installed, "ltex-ls")
end

return options
