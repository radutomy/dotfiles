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
							Comment = { fg = colors.green, bg = "NONE", italic = true }, -- Grey color for comments
							-- CursorLineNr = { fg = "#FFC800", bg = "NONE", bold = true }, -- Bright yellow for the current line number
							Keyword = { fg = colors.blue, bg = "NONE" }, -- Blue for keywords
							String = { fg = colors.orange, bg = "NONE" }, -- Orange for strings
							Type = { fg = "#4EC9B0", bg = "NONE" }, -- Teal for types
							Function = { fg = "#56B6C2", bg = "NONE" }, -- Purple for functions
							Constant = { fg = colors.white, bg = "NONE" }, -- this is a weird one
							-- BlinkCmpMenu = { fg = "#FFFFFF" },
							-- BlinkCmpDoc = { fg = "#FFFFFF" },
							BlinkCmpMenuSelection = { fg = colors.white, bg = "#264f78" },
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
			-- colorscheme = "tokyonight",
		},
	},
}
