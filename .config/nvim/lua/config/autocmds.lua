-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance
-- removes border from neovim in the terminal
local modified = false
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
	callback = function()
		local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
		if normal.bg then
			io.write(string.format("\027]11;#%06x\027\\", normal.bg))
			modified = true
		end
	end,
})

vim.api.nvim_create_autocmd("UILeave", {
	callback = function()
		if modified then
			io.write "\027]111\027\\"
		end
	end,
})

-- format (and save) the document for these events
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	pattern = "*",
	callback = function()
		vim.schedule(function()
			-- Check if buffer is writable
			if vim.bo.buftype == "" and vim.bo.modifiable then
				require("conform").format()
				vim.cmd "write"
			end
		end)
	end,
	desc = "Format on yank and before save",
})

-- Force kill terminal when :qa
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*toggleterm#*",
	callback = function(args)
		vim.cmd "setlocal bufhidden=hide"
		vim.b[args.buf].terminal_kill_on_exit = "term"
	end,
})
