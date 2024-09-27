-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = ""
-- disable auto comment
vim.cmd [[autocmd FileType * set formatoptions-=ro]]

vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smarttab = true
vim.opt.signcolumn = "yes:1" -- make the gutter smaller

vim.opt.timeoutlen = 1000
