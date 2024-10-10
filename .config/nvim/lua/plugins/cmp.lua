return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require "cmp"
			local context = require "cmp.config.context"

			-- Set tab to select the first item in the autocomplete pop-up
			opts.mapping = vim.tbl_extend("force", opts.mapping, {
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						local entry = cmp.get_selected_entry()
						if not entry then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							cmp.confirm()
						end
					else
						fallback()
					end
				end, { "i", "s", "c" }),
			})

			-- Disable completion in comments and strings
			opts.enabled = function()
				if vim.api.nvim_get_mode().mode == "c" then
					return true -- Enable completion in command mode
				else
					-- Disable in comments and strings
					local in_comment = context.in_treesitter_capture "comment" or context.in_syntax_group "Comment"
					local in_string = context.in_treesitter_capture "string" or context.in_syntax_group "String"
					return not in_comment and not in_string
				end
			end
		end,
	},

	-- LuaSnip is needed only if you're using snippets with nvim-cmp
	{
		"L3MON4D3/LuaSnip",
		keys = function()
			return {}
		end,
	},
}
