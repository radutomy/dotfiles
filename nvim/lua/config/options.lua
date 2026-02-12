-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable auto comment
vim.cmd [[autocmd FileType * set formatoptions-=ro]]

local o = vim.opt

o.clipboard = ""
o.autoindent = true
o.smarttab = true
o.smartindent = true
o.signcolumn = "yes:1" -- make the gutter smaller
o.wrap = true

o.timeoutlen = 300
o.ttimeoutlen = 50
o.updatetime = 100
o.autoread = true

-- disable built-in completion
o.complete = ""
o.completeopt = ""

-- Disable transparency for floating windows
-- o.winblend = 0
o.pumblend = 0

-- Rustaceanvim: use cargo check instead of clippy on save (faster)
vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'check',
        },
      },
    },
  },
}
