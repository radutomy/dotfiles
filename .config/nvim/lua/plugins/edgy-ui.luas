return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		init = function()
			vim.opt.laststatus = 3
			vim.opt.splitkeep = "screen"
		end,
		opts = {
			exit_when_last = true,
			bottom = {
				{
					ft = "lazyterm",
					title = "LazyTerm",
					size = { height = 0.3 },
					filter = function(buf)
						return not vim.b[buf].lazyterm_cmd
					end,
				},
			},
			left = {
				{
					title = "Neo-Tree",
					ft = "neo-tree",
					filter = function(buf)
						return vim.b[buf].neo_tree_source == "filesystem"
					end,
					size = { height = 0.7 },
				},
				{
					title = "Neo-Tree Git",
					ft = "neo-tree",
					filter = function(buf)
						return vim.b[buf].neo_tree_source == "git_status"
					end,
					size = { height = 0.3 },
					pinned = true,
					collapsed = false,
					open = "Neotree position=right git_status",
				},
			},
		},
	},
}
