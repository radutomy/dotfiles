return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
			"onsails/lspkind-nvim", -- Add lspkind for icons
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require "cmp"
			local lspkind = require "lspkind"
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
			-- Modify lspkind to show icons only, placed to the left of the completion text
			opts.formatting = {
				fields = { "kind", "abbr" }, -- Display "kind" (icon) first
				format = function(entry, vim_item)
					-- Use lspkind for the icons
					vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol" }) .. " " -- Add two spaces after icon
					-- Remove the tilde or any extra characters
					vim_item.abbr = vim_item.abbr:gsub("~", "") -- Remove tilde
					vim_item.menu = nil -- Remove extra menu items
					return vim_item
				end,
			}
			-- Sort fields, properties, functions, and methods first
			opts.sorting = {
				priority_weight = 2,
				comparators = {
					-- Prioritize fields, properties, functions, and methods
					function(entry1, entry2)
						local kind1 = entry1:get_kind()
						local kind2 = entry2:get_kind()
						-- Priority: Field > Property > Function > Method
						local priority = {
							[cmp.lsp.CompletionItemKind.Field] = 1,
							[cmp.lsp.CompletionItemKind.Property] = 2,
							[cmp.lsp.CompletionItemKind.Function] = 3,
							[cmp.lsp.CompletionItemKind.Method] = 4,
						}
						-- Compare priorities if both are in the priority list
						if priority[kind1] and priority[kind2] then
							return priority[kind1] < priority[kind2]
						elseif priority[kind1] then
							return true -- Kind1 has priority
						elseif priority[kind2] then
							return false -- Kind2 has priority
						end
					end,
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			}
			-- Adjust the completion window size and layout with non-transparent background
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26" })
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1b26", fg = "#c0caf5" })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#283457", fg = "#c0caf5" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1b26", fg = "#3b4261" })
			vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1a1b26" })
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#c0c0c0", bg = "#1a1b26" }) -- White border with dark background

			-- Complete window override
			opts.window = {
				completion = cmp.config.window.bordered({
					scrollbar = false,
					-- col_offset = -3,
					-- side_padding = 0,
					winhighlight = "Normal:CmpNormal,NormalFloat:CmpNormal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					border = "single",
				}),
				documentation = cmp.config.window.bordered({
					scrollbar = false,
					border = "rounded",
					winhighlight = "Normal:CmpNormal,NormalFloat:CmpNormal,FloatBorder:FloatBorder",
				}),
			}
			-- Limit the max width of completion entries
			opts.formatting.maxwidth = 50 -- Max width of the completion text
			opts.formatting.ellipsis_char = "..." -- Truncate long items with ellipsis
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
