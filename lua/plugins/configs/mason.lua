local options = {
  ensure_installed = {
    --webdev
    -- "html-lsp",
    -- "css-lsp",
    -- "prettierd",
    -- "eslint-lsp",
    -- "eslint_d",
    -- lua
    "lua-language-server",
    "stylua",
    -- -- python
    "pyright",
    "black",
    "debugpy",
    -- latex
    "ltex-ls", -- latex and markdown
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
    -- c
    -- "clangd",
    -- "clang-format", -- c and java
    -- java
    -- "jdtls",
    -- rust
    "rust-analyzer",
    "rustfmt",
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

return options
