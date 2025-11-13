-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- format (and save) the document for these events
-- vim.api.nvim_create_autocmd({ "TextYankPost" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.schedule(function()
-- 			-- Check if buffer is writable and has a filename
-- 			if vim.bo.buftype == "" and vim.bo.modifiable and vim.api.nvim_buf_get_name(0) ~= "" then
-- 				require("conform").format()
-- 				vim.cmd "write"
-- 			end
-- 		end)
-- 	end,
-- 	desc = "Format on yank and before save",
-- })

-- Force kill terminal when :qa
vim.api.nvim_create_autocmd("QuitPre", {
	group = vim.api.nvim_create_augroup("TerminalClose", { clear = true }),
	callback = function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buftype == "terminal" and vim.b[buf].terminal_job_id then
				vim.fn.jobstop(vim.b[buf].terminal_job_id)
			end
		end
	end,
	nested = true,
})
