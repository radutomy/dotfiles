return {
	"saghen/blink.cmp",
	opts = function(_, opts)
		opts.cmdline = { enabled = false }

		opts.keymap = {
			preset = "super-tab",
			["<C-j>"] = { "select_prev", "fallback" },
			["<C-k>"] = { "select_next", "fallback" },
		}
		opts.sources = {
			default = { "lsp", "path" },
			providers = {
				buffer = { enabled = false },
				snippets = { enabled = false },
			},
		}
		opts.completion = {
			menu = {
				border = "single",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = {
					border = "single",
				},
			},
		}
		return opts
	end,
}
