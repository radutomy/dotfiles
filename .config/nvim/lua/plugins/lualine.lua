return {
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			-- remove date and time from the far-right corner
			opts.sections.lualine_z = {}
			-- show only the filename
			opts.sections.lualine_c = { { "filename", path = 0, icon = "󰈙 ", color = { fg = "#7CB342" } } }
		end,
	},
}
