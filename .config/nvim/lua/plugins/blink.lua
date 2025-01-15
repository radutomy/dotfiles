return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = "rafamadriz/friendly-snippets",

	-- use a release tag to download pre-built binaries
	version = "*",

	signature = { enabled = true },

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "super-tab" },

		sources = {
			default = { "lsp", "path" },
		},

		completion = {
			menu = {
				border = "single",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 50,
				window = {
					border = "single",
				},
			},
			-- Displays a preview of the selected item on the current line
			ghost_text = {
				enabled = false,
			},
		},
	},
}
