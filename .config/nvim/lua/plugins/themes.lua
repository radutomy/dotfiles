return {
	-- { "EdenEast/nightfox.nvim" },
	{
		-- https://github.com/scottmckendry/cyberdream.nvim?tab=readme-ov-file#%EF%B8%8F-configuring
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				italic_comments = false,
				highlights = {
					Comment = { fg = "#9BB5D6", italic = false },
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
