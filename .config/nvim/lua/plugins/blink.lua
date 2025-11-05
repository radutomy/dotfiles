return {
	"saghen/blink.cmp",
	version = "*",
	signature = { enabled = true },
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "super-tab" },
		sources = {
			default = { "lsp", "path" },
			providers = {
				buffer = { enabled = false },
				snippets = { enabled = false },
			},
		},
		completion = {
			menu = {
				border = "single",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
				window = {
					border = "single",
				},
			},
			ghost_text = {
				enabled = false,
			},
		},
	},
}
