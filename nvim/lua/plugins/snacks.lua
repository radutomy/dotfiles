return {
	"folke/snacks.nvim",
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "PersistenceLoadPost",
			callback = function()
				Snacks.picker.explorer()
				vim.defer_fn(function() vim.cmd "wincmd l" end, 10)
			end,
		})
	end,
	opts = {
		scroll = {
			animate = {
				duration = { step = 20, total = 120 },
				easing = "linear",
			},
		},
		lazygit = {
			config = {
				os = {
					edit = 'nvim --server "$NVIM" --remote-send "<Cmd>close<CR><Cmd>edit {{filename}}<CR>"',
				},
			},
			win = {
				on_win = function() end,
			},
		},
		picker = {
			win = {
				input = {
					keys = {
						["<Esc>"] = { "close", mode = { "i", "n" } },
					},
				},
			},
			formatters = {
				file = {
					filename_first = true,
					truncate = 80, -- path is set to this many characters max
				},
			},
			sources = {
				explorer = {
					auto_close = false, -- Prevent auto-closing when focusing other windows
					jump = { close = false }, -- Don't close when jumping to files
					follow_file = true, -- Automatically reveal current file in explorer
					hidden = true, -- Show hidden files by default
					layout = {
						hidden = { "input" }, -- Hide the search bar
						layout = {
							width = 0.20, -- 25% of screen width (dynamic)
							-- min_width = 32,
							position = "left",
						},
					},
					win = {
						list = {
							keys = {
								["<Esc>"] = false,
								["<C-n>"] = false,
								["<Tab>"] = false,
							},
						},
					},
				},
			},
		},
		terminal = {
			win = {
				position = "float",
				on_win = function()
					vim.schedule(function()
						local k, b = vim.keymap.set, vim.api.nvim_get_current_buf()
						k("t", "<C-u>", "<C-\\><C-n><C-u>zz", { buffer = b })
						k("t", "<C-d>", "<Nop>", { buffer = b })
						k("n", "<C-d>", function()
							vim.cmd "normal! \x04zz"
							if vim.fn.line "w$" == vim.fn.line "$" then vim.cmd "startinsert" end
						end, { buffer = b })
						k("t", "<Esc>", "<cmd>close<cr>", { buffer = b })
						k("n", "<Esc>", "<cmd>close<cr>", { buffer = b })
					end)
				end,
			},
		},
	},
	keys = {
		-- Explorer
		{
			"<leader>e",
			function() Snacks.picker.explorer() end,
			desc = "File Explorer",
		},
		{
			"<leader>fF",
			function() Snacks.picker.files({ cwd = LazyVim.root() }) end,
			desc = "Find Files (Root Dir)",
		},
		{
			"<leader>ff",
			function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end,
			desc = "Find Files (cwd)",
		},
		{
			"<leader><space>",
			function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end,
			desc = "Find Files (cwd)",
		},
	},
}
