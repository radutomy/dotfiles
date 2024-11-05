return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			direction = "float",
			open_mapping = [[<C-t>]],
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
			on_open = function()
				vim.cmd "startinsert" -- Ensure Insert mode on open
				vim.opt_local.mouse = "" -- Disable mouse for terminal buffer
			end,
			on_focus = function()
				vim.cmd "startinsert" -- Re-enter Insert mode on focus
			end,
		},
	},
}
