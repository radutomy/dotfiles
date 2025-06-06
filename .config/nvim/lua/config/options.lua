-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable auto comment
vim.cmd [[autocmd FileType * set formatoptions-=ro]]

local o = vim.opt

o.clipboard = ""
o.autoindent = true
o.expandtab = false
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.smarttab = true
o.smartindent = true
o.signcolumn = "yes:1" -- make the gutter smaller
o.wrap = true

o.timeoutlen = 300
o.ttimeoutlen = 50

-- disable built-in completion
o.complete = ""
o.completeopt = ""

-- Disable transparency for floating windows
-- o.winblend = 0
o.pumblend = 0
