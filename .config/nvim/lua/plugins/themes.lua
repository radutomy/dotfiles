return {
	-- { "EdenEast/nightfox.nvim" },
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				theme = {
					overrides = function(colors)
						return {
							Comment = { fg = colors.grey, bg = "NONE", italic = true }, -- Dark green color for comments
							-- LineNr = { fg = "#FFC800", bg = "NONE" }, -- Color for normal line numbers
							CursorLineNr = { fg = "#FFC800", bg = "NONE", bold = true }, -- Color for the current line number
							Keyword = { fg = colors.blue, bg = "NONE" }, -- Use blue for keywords
							String = { fg = colors.orange, bg = "NONE" }, -- Use yellow/orange for types
							Type = { fg = "#4EC9B0", bg = "NONE" }, -- Use yellow/orange for types
							Function = { fg = "#A53FD6", bg = "NONE" }, -- Use purple for methods
						}
					end,
					colors = {
						green = "#25BE6A",
					},
				},
			})
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "cyberdream",
		},
	},
}
