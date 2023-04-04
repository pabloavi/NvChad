local opt = vim.opt
local g = vim.g
local config = require("core.utils").load_config()

g.nvchad_theme = config.ui.theme
g.toggle_theme_icon = "   " -- TODO: remove toggle theme
g.transparency = config.ui.transparency
g.theme_switcher_loaded = false

g.lsp_lines_enabled = false -- custom

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.scrolloff = 8

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
-- opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 0 -- default was 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false
opt.relativenumber = true

-- Completion
opt.pumheight = 5
opt.cmdheight = 1

-- disable nvim intro & swapfile attention message
opt.shortmess:append "sIA"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- nvim-ufo
-- vim.o.foldcolumn = "1"
-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

g.mapleader = " "

-- vimtex
g.vimtex_syntax_enabled = 1
g.vimtex_syntax_conceal_disable = 1
g.use_treesitter = true -- custom made (for snippets, to use vimtex o treesitter syntax)

g.tex_flavor = "latex"
g.AirLatexUsername = io.popen("echo $AIRLATEX_USERNAME"):read "*l" -- read from env var for security reasons
g.AirLatexAllowInsecure = 1
-- g.AirLatexLogLevel = "DEBUG"
g.AirLatexCookieBrowser = "firefox"

-- neovide options
if vim.g.neovide then
  vim.opt.guifont = { "JetBrainsMono Nerd Font:h12" }
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_transparency = 1
  vim.g.neovide_floating_opacity = 1
end

-- firenvim
if vim.g.started_by_firenvim == true then
  opt.laststatus = 0
  opt.cmdheight = 0
  opt.pumheight = 1
end

-- netrw
g.netrw_localrmdir = "rmtrash -r"
g.netrw_localcopydircmd = "cp -r"
g.netrw_banner = 0

-- disable some default providers
for _, provider in ipairs { "node", "perl", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath "data" .. "/mason/bin"

-------------------------------------- autocmds ------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- fix neovim startup artifact
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local pid, WINCH = vim.fn.getpid(), vim.loop.constants.SIGWINCH
    vim.defer_fn(function()
      vim.loop.kill(pid, WINCH)
    end, 20)
  end,
})

-- resize splits when resizing the window
autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd [[wincmd =]]
  end,
})

-- give .config/sxhkd/sxhkdrc its own filetype
autocmd({ "BufReadPost" }, {
  pattern = "/sxhkdrc",
  callback = function()
    vim.bo.filetype = "sxhkdrc"
  end,
})

-- reload some chadrc options on-save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.tbl_map(vim.fs.normalize, vim.fn.glob(vim.fn.stdpath "config" .. "/lua/**/*.lua", true, true, true)),
  group = vim.api.nvim_create_augroup("ReloadNvChad", {}),

  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r") --[[@as string]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
    local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")

    require("plenary.reload").reload_module "base46"
    require("plenary.reload").reload_module(module)
    require("plenary.reload").reload_module "core.config"

    config = require("core.utils").load_config()

    vim.g.nvchad_theme = config.ui.theme
    vim.g.transparency = config.ui.transparency

    -- statusline
    require("plenary.reload").reload_module("nvchad_ui.statusline." .. config.ui.statusline.theme)
    vim.opt.statusline = "%!v:lua.require('nvchad_ui.statusline." .. config.ui.statusline.theme .. "').run()"

    require("base46").load_all_highlights()
    -- vim.cmd("redraw!")
  end,
})

-------------------------------------- commands ------------------------------------------
local new_cmd = vim.api.nvim_create_user_command

new_cmd("NvChadUpdate", function()
  require "nvchad.update"()
end, {})

new_cmd("EnableAutosave", function()
  require("auto-save").setup()
end, {})

new_cmd("EnableSnippetConverter", function()
  require "snippet-converter"
end, {})

-- cd to current file's directory
new_cmd("C", function()
  vim.cmd "silent cd %:h"
end, {})
-- vim.cmd "C"

new_cmd("VimStartupTime", function()
  require "vim-startuptime"
  vim.cmd "StartupTime"
end, {})
