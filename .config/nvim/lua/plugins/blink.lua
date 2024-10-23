return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	-- optional: provides snippets for the snippet source
	dependencies = "rafamadriz/friendly-snippets",

	-- use a release tag to download pre-built binaries
	version = "v0.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		highlight = {
			-- use_nvim_cmp_as_default = true,
		},
		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- adjusts spacing to ensure icons are aligned
		nerd_font_variant = "normal",

		-- experimental auto-brackets support
		accept = { auto_brackets = { enabled = true } },

		-- experimental signature help support
		trigger = { signature_help = { enabled = true, show_on_insert_on_trigger_character = true } },
		-- fuzzy = { sorts = { "kind", "label", "score" } },
		sources = { providers = { { "blink.cmp.sources.lsp", name = "LSP" } } },
		windows = {
			autocomplete = {
				min_width = 50,
				max_width = 100,
				max_height = 10,
				border = "rounded",
				scrolloff = 2,
				direction_priority = { "s", "n" },
				auto_show = true,
				draw = "simple",
			},
			documentation = {
				min_width = 15,
				max_width = 50,
				max_height = 20,
				border = "rounded",
				direction_priority = {
					autocomplete_north = { "e", "w", "n", "s" },
					autocomplete_south = { "e", "w", "s", "n" },
				},
				auto_show = true,
				-- auto_show_delay_ms = 500,
				-- update_delay_ms = 100,
			},
		},
		kind_icons = {
			Text = "",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰇽",
			Variable = "󰂡",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "󰅱",
			Color = "󰏘",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰅲",
		},
	},
}
