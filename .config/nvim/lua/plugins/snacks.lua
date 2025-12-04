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
		vim.api.nvim_create_autocmd("TermOpen", {
			callback = function(ev)
				if vim.bo[ev.buf].filetype == "snacks_terminal" then
					vim.api.nvim_buf_set_keymap(ev.buf, "t", "<C-h>", "", { callback = function() vim.fn.system("tmux previous-window") end })
					vim.api.nvim_buf_set_keymap(ev.buf, "t", "<C-l>", "", { callback = function() vim.fn.system("tmux next-window") end })
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
				on_win = function()
					vim.o.mouse = ""
					vim.fn.system("tmux set-option -p @pane-is-vim yes")
					vim.keymap.set("t", "<C-u>", "<C-\\><C-n><C-u>", { buffer = true })
					vim.keymap.set("t", "<C-d>", "<Nop>", { buffer = true })
					vim.keymap.set("n", "<C-d>", function()
						if vim.fn.line("w$") == vim.fn.line("$") then return vim.cmd("startinsert") end
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "n", false)
						vim.schedule(function() if vim.fn.line("w$") == vim.fn.line("$") then vim.cmd("startinsert") end end)
					end, { buffer = true })
					vim.keymap.set("n", "<Esc>", "<cmd>startinsert<cr>", { buffer = true })
					vim.keymap.set("n", "<C-h>", function() if vim.env.TMUX then vim.fn.system("tmux previous-window") end end, { buffer = true })
					vim.keymap.set("n", "<C-l>", function() if vim.env.TMUX then vim.fn.system("tmux next-window") end end, { buffer = true })
				end,
				on_close = function() vim.o.mouse = "a"; vim.fn.system("tmux set-option -p -u @pane-is-vim") end,
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
