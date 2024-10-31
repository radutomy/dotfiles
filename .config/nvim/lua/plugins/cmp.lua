return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
			"onsails/lspkind-nvim",
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require "cmp"
			local lspkind = require "lspkind"
			local context = require "cmp.config.context"

			-- Define VS Code-like colors for different types
			local kind_colors = {
				Class = "#EE9D28",
				Color = "#0A7ACA",
				Constant = "#A31515",
				Constructor = "#317AC6",
				Enum = "#9876AA",
				EnumMember = "#6796E6",
				Event = "#C586C0",
				Field = "#787CB5",
				File = "#4EC9B0",
				Folder = "#DAB98F",
				Function = "#C586C0",
				Interface = "#4EC9B0",
				Keyword = "#569CD6",
				Method = "#C586C0",
				Module = "#4EC9B0",
				Operator = "#D4D4D4",
				Property = "#DCDCAA",
				Reference = "#9CDCFE",
				Snippet = "#1B75BB",
				Struct = "#4EC9B0",
				Text = "#9CDCFE",
				TypeParameter = "#4EC9B0",
				Unit = "#D4D4D4",
				Value = "#9CDCFE",
				Variable = "#9CDCFE",
			}

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
					return true
				else
					local in_comment = context.in_treesitter_capture "comment" or context.in_syntax_group "Comment"
					local in_string = context.in_treesitter_capture "string" or context.in_syntax_group "String"
					return not in_comment and not in_string
				end
			end

			-- Modified formatting to include colors with nil check
			opts.formatting = {
				fields = { "kind", "abbr" },
				format = function(entry, vim_item)
					local kind = vim_item.kind
					if kind then -- Add nil check here
						local color = kind_colors[kind] or "#FFFFFF"
						-- Create highlight group for this kind
						local hl_group = "CmpItemKind" .. kind
						vim.api.nvim_set_hl(0, hl_group, { fg = color })

						-- Use lspkind for the icons with color
						local symbol = lspkind.symbolic(kind, { mode = "symbol" })
						vim_item.kind = (symbol and (symbol .. " ")) or (kind .. " ")
						vim_item.kind_hl_group = hl_group -- Apply the highlight group
					else
						vim_item.kind = "Text " -- Default fallback
					end

					-- Remove the tilde and menu
					vim_item.abbr = vim_item.abbr:gsub("~", "")
					vim_item.menu = nil

					return vim_item
				end,
			}

			-- Window styling
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26" })
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1b26", fg = "#c0caf5" })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#283457", fg = "#c0caf5" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1b26", fg = "#3b4261" })
			vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1a1b26" })
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#c0c0c0", bg = "#1a1b26" })

			opts.window = {
				completion = cmp.config.window.bordered({
					scrollbar = false,
					winhighlight = "Normal:CmpNormal,NormalFloat:CmpNormal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					border = "single",
				}),
				documentation = cmp.config.window.bordered({
					scrollbar = false,
					border = "rounded",
					winhighlight = "Normal:CmpNormal,NormalFloat:CmpNormal,FloatBorder:FloatBorder",
				}),
			}

			opts.formatting.maxwidth = 50
			opts.formatting.ellipsis_char = "..."
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		keys = function()
			return {}
		end,
	},
}
