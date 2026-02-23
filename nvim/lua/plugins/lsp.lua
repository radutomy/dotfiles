return {
	"neovim/nvim-lspconfig",
	opts = {
		diagnostics = {
			virtual_text = false,
			signs = { text = { "●", "●", "●", "●" } }, -- error, warn, info, hint
			float = { border = "rounded", source = true, focusable = true },
			severity_sort = true,
		},
		-- Recognize `vim` as a global to suppress undefined-global warnings
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
		},
	},
	init = function()
		-- Show diagnostics floating window on cursor hover
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function() vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" }) end,
		})
	end,
}
