return {
	"folke/snacks.nvim",
	opts = {
		scroll = {
			animate = {
				duration = { step = 20, total = 120 },
				easing = "linear",
			},
		},
		picker = {
			formatters = {
				file = {
					filename_first = true,
					truncate = 80, -- path is set to this many characters max
				},
			},
			sources = {
				explorer = {
					auto_close = false, -- Prevent auto-closing when focusing other windows
					jump = { close = false }, -- Don't close when jumping to files
					follow_file = true, -- Automatically reveal current file in explorer
					hidden = true, -- Show hidden files by default
					layout = {
						hidden = { "input" }, -- Hide the search bar
						layout = {
							width = 0.20, -- 25% of screen width (dynamic)
							-- min_width = 32,
							position = "left",
						},
					},
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
		-- Add a key for the explorer
		{
			"<leader>e",
			function()
				Snacks.picker.explorer()
			end,
			desc = "File Explorer",
		},
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
