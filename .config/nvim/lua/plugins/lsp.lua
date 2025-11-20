return {
	"neovim/nvim-lspconfig",
	opts = {
		diagnostics = {
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "●",
					[vim.diagnostic.severity.WARN] = "●",
					[vim.diagnostic.severity.HINT] = "●",
					[vim.diagnostic.severity.INFO] = "●",
				},
			},
			float = { border = "rounded" },
		},
	},
	init = function()
		-- Show diagnostics float on cursor hold
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function() vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" }) end,
		})
	end,
}
