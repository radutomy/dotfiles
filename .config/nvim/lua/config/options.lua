-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable auto comment
vim.cmd [[autocmd FileType * set formatoptions-=ro]]

--vim.g.rust_recommended_style = false

local o = vim.opt

o.clipboard = ""
o.autoindent = false
o.expandtab = false
o.tabstop = 3
o.shiftwidth = 3
o.softtabstop = 3
o.smarttab = true
o.signcolumn = "yes:1" -- make the gutter smaller

o.timeoutlen = 300
o.ttimeoutlen = 50
