return {
	-- Plugin: auto-save.nvim
	-- Source: https://github.com/pocco81/auto-save.nvim
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup({
				enabled = true,
				execution_message = {
					message = function()
						return ""
					end,
					dim = 0.18,
					cleaning_interval = 1250,
				},
				trigger_events = { "InsertLeave", "TextChanged" },
				condition = function(buf)
					local fn = vim.fn
					local utils = require "auto-save.utils.data"

					if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
						return true
					end
					return false
				end,
				write_all_buffers = false,
				debounce_delay = 135,
				callbacks = {
					enabling = nil,
					disabling = nil,
					before_asserting_save = nil,
					before_saving = nil,
					after_saving = nil,
				},
			})
		end,
	},
}
