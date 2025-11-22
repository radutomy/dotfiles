return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"f-person/git-blame.nvim", -- Add git-blame plugin as a dependency
		},
		opts = function(_, opts)
			opts.options = opts.options or {}

			-- Custom theme based on vscode with darker normal mode text
			local vscode = require "lualine.themes.vscode"
			vscode.normal.a.fg = "#1e1e1e"
			opts.options.theme = vscode

			-- git-blame integration: https://github.com/f-person/git-blame.nvim?tab=readme-ov-file#statusline-integration
			local git_blame = require "gitblame"
			vim.g.gitblame_display_virtual_text = 0
			vim.g.gitblame_date_format = "%r"
			vim.g.gitblame_message_template = "  <author> • <date> • <summary>"

			-- remove date and time from the far-right corner
			opts.sections.lualine_z = {}

			opts.sections.lualine_c = {
				{
					"filename",
					path = 1,
					icon = "󰈙 ",
					color = { fg = "#7CB342" },
					symbols = {
						modified = "[+]",
						readonly = "[-]",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
				},
				{
					git_blame.get_current_blame_text,
					cond = git_blame.is_blame_text_available,
					color = { fg = "#666666" }, -- Added grey color
				},
			}
		end,
	},
}
