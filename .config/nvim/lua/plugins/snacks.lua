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
		vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
			callback = function(e)
				if vim.bo[e.buf].buftype == "terminal" and vim.bo[e.buf].filetype == "snacks_terminal" then
					for k, c in pairs({ ["<C-h>"] = "previous-window", ["<C-l>"] = "next-window" }) do
						vim.api.nvim_buf_set_keymap(
							e.buf,
							"t",
							k,
							"",
							{ callback = function() vim.fn.system("tmux " .. c) end }
						)
					end
				end
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
								["<C-h>"] = function()
									if vim.env.TMUX then vim.fn.jobstart({ "tmux", "previous-window" }) end
								end,
								["<C-j>"] = function()
									if vim.env.TMUX then vim.fn.jobstart({ "tmux", "select-pane", "-D" }) end
								end,
								["<C-k>"] = function()
									if vim.env.TMUX then vim.fn.jobstart({ "tmux", "select-pane", "-U" }) end
								end,
								["<C-l>"] = function() vim.cmd "wincmd l" end,
							},
						},
					},
				},
			},
		},
		terminal = {
			win = {
				position = "float",
				-- there be dragons here
				on_win = function()
					local k, b = vim.keymap.set, vim.api.nvim_get_current_buf()
					vim.o.mouse = ""
					vim.fn.system "tmux set-option -p @pane-is-vim yes"
					k("t", "<C-u>", "<C-\\><C-n><C-u>", { buffer = 0 })
					k("t", "<C-d>", "<Nop>", { buffer = 0 })
					vim.schedule(function()
						for key, cmd in pairs({ ["<C-h>"] = "previous-window", ["<C-l>"] = "next-window" }) do
							vim.api.nvim_buf_set_keymap(
								b,
								"t",
								key,
								"",
								{ callback = function() vim.fn.system("tmux " .. cmd) end }
							)
						end
					end)
					k("n", "<C-d>", function()
						vim.cmd "normal! \x04"
						if vim.fn.line "w$" == vim.fn.line "$" then vim.cmd "startinsert" end
					end, { buffer = 0 })
					k("n", "<Esc>", "<cmd>startinsert<cr>", { buffer = 0 })
					for key, cmd in pairs({ ["<C-h>"] = "previous-window", ["<C-l>"] = "next-window" }) do
						k("n", key, function() vim.fn.system("tmux " .. cmd) end, { buffer = 0 })
					end
				end,
				on_close = function()
					vim.o.mouse = "a"
					-- Re-set @pane-is-vim instead of unsetting it
					vim.fn.system "tmux set-option -p @pane-is-vim yes"
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
