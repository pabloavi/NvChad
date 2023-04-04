local mason_nvim_dap = require "mason-nvim-dap"
mason_nvim_dap.setup(opts) -- run setup
-- do more configuration as needed
mason_nvim_dap.setup_handlers {
  python = function(source_name)
    local dap = require "dap"
    dap.adapters.python = {
      type = "executable",
      command = "/usr/bin/python3",
      args = {
        "-m",
        "debugpy.adapter",
      },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}", -- This configuration will launch the current file if used.
      },
    }
  end,
}
