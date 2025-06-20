return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			direction = "float",
			open_mapping = [[<C-/>]],
			float_opts = {
				border = "curved",
				width = function()
					return math.floor(vim.o.columns * 0.95)
				end,
				height = function()
					return math.floor(vim.o.lines * 0.9)
				end,
			},
			persist_size = true,
			persist_mode = true,
			close_on_exit = true,
			start_in_insert = true,

			-- Custom settings to disable mouse in terminal mode
			on_open = function(term)
				vim.cmd "startinsert" -- Start in Insert mode
				vim.opt.mouse = "" -- Disable mouse globally
				vim.api.nvim_buf_set_keymap(
					term.bufnr,
					"t",
					"<Esc>",
					[[<C-\><C-n>:silent! execute v:count1 . "ToggleTerm"<CR>]],
					{ noremap = true, silent = true }
				)
				vim.api.nvim_create_autocmd("BufLeave", { -- Re-enable mouse on leaving terminal buffer
					buffer = term.bufnr,
					callback = function()
						vim.opt.mouse = "a" -- Set your preferred mouse setting here
					end,
				})
			end,
			on_focus = function()
				vim.cmd "startinsert" -- Re-enter Insert mode on focus
			end,
		},
	},
}
