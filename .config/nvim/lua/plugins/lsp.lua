return {
	"neovim/nvim-lspconfig",
	opts = {
		diagnostics = {
			virtual_text = false,
			signs = true,
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
