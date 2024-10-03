return {
	"echasnovski/mini.files",
	lazy = false,
	opts = {
		windows = {
			max_number = math.huge,
			preview = true,
			width_focus = 30,
			width_preview = 30,
		},
		options = {
			-- Whether to use for editing directories
			-- Disabled by default in LazyVim because neo-tree is used for that
			use_as_default_explorer = true,
			permanent_delete = true,
		},
	},
	keys = {
		{
			"<leader>e",
			function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
			end,
			desc = "Open mini.files (Directory of Current File)",
		},
		{
			"<leader>E",
			function()
				require("mini.files").open(vim.uv.cwd(), true)
			end,
			desc = "Open mini.files (cwd)",
		},
	},
}
