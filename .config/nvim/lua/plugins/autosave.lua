return {
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
					before_saving = function()
						vim.schedule(function()
							-- Any additional async operations can go here
						end)
					end,
					after_saving = function()
						vim.schedule(function()
							-- Post-save async operations can go here
						end)
					end,
				},
			})
		end,
	},
}
