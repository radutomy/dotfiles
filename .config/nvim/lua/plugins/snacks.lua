return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		picker = {
			-- refer to the configuration section below
			formatters = {
				file = {
					filename_first = true,
				},
			},
		},
	},
}
