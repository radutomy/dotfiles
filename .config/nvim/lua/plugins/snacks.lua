return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			-- refer to the configuration section below
			formatters = {
				file = {
					filename_first = true,
					truncate = 80,
				},
			},
		},
		terminal = {
			win = {
				position = "float",
			},
		},
	},
	keys = {
		{
			"<leader>fF",
			function()
				Snacks.picker.files({ cwd = LazyVim.root() })
			end,
			desc = "Find Files (Root Dir)",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ cwd = vim.fn.getcwd() })
			end,
			desc = "Find Files (cwd)",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.files({ cwd = vim.fn.getcwd() })
			end,
			desc = "Find Files (cwd)",
		},
	},
}
