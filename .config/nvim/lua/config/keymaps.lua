-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- j/k special handling to move to the first non-blank character of the line
-- vim.keymap.set("n", "j", "j^", { noremap = true, silent = true })
-- vim.keymap.set("n", "k", "k^", { noremap = true, silent = true })

-- vim.keymap.set("n", "j", function()
-- 	vim.cmd "normal! j"
-- 	local col = vim.fn.col "."
-- 	local line = vim.fn.getline "."
-- 	local first_non_blank = vim.fn.match(line, "\\S") + 1
-- 	if first_non_blank > 0 and col < first_non_blank then
-- 		vim.fn.cursor(vim.fn.line ".", first_non_blank)
-- 	end
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set("n", "k", function()
-- 	vim.cmd "normal! k"
-- 	local col = vim.fn.col "."
-- 	local line = vim.fn.getline "."
-- 	local first_non_blank = vim.fn.match(line, "\\S") + 1
-- 	if first_non_blank > 0 and col < first_non_blank then
-- 		vim.fn.cursor(vim.fn.line ".", first_non_blank)
-- 	end
-- end, { noremap = true, silent = true })

-- CTRL D/U moves up and down and centers
vim.keymap.set("n", "<C-u>", "10k zz", { desc = "Move 5 lines up" })
vim.keymap.set("n", "<C-d>", "10j zz", { desc = "Move 5 lines down" })
vim.keymap.set("n", "<C-f>", "10j zz", { desc = "Move 5 lines down" })

-- Fix indentation for i, a, A and I
for _, key in ipairs({ "i", "a", "A", "I" }) do
	vim.keymap.set("n", key, function()
		return vim.fn.trim(vim.fn.getline ".") == "" and '"_cc' or key
	end, { expr = true })
end

-- In normal mode, Ctrl+V creates a new line, and pastes from the system clipboard
vim.keymap.set("n", "<C-v>", function()
	vim.cmd "normal! $o"
	vim.cmd [[normal! "+p]]
end, { noremap = true, silent = true })

-- In normal and visual modes, Ctrl+C yanks either the current line (in normal mode)
-- or the selection (in visual mode) to the system clipboard, trimming leading and trailing whitespace
vim.keymap.set({ "n", "x" }, "<C-c>", function()
	vim.cmd('normal! "+' .. (vim.fn.mode() == "n" and "yy" or "y"))
	vim.fn.setreg("+", vim.fn.getreg("+"):match "^%s*(.-)%s*$")
end, { noremap = true, silent = true })

-- -- F2 - show function signature
-- vim.keymap.set("n", "<F2>", vim.lsp.buf.signature_help, { noremap = true, silent = true })
--
-- -- F3 - show hover docs (what K does)
-- vim.keymap.set("n", "<F3>", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "LSP Hover" })

-- F3 - Toggle context-aware documentation and function signature
vim.keymap.set("n", "<F3>", function()
	-- Close floating windows if any exist
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local ok, config = pcall(vim.api.nvim_win_get_config, win)
		if ok and config.relative ~= "" then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	-- Open appropriate documentation
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local before = line:sub(1, col + 1)
	local parens = 0

	for i = #before, 1, -1 do
		local c = before:sub(i, i)
		if c == ")" then
			parens = parens - 1
		elseif c == "(" then
			parens = parens + 1
		end
		if parens > 0 then
			return vim.lsp.buf.signature_help()
		end
	end
	vim.lsp.buf.hover()
end, { noremap = true, silent = true, desc = "Toggle LSP docs" })

-- -- Close floating windows with Escape
-- vim.keymap.set("n", "<Esc>", function()
-- 	for _, win in ipairs(vim.api.nvim_list_wins()) do
-- 		local config = vim.api.nvim_win_get_config(win)
-- 		if config.relative ~= "" then -- is floating window
-- 			vim.api.nvim_win_close(win, false)
-- 		end
-- 	end
-- end, { noremap = true, silent = true, desc = "Close floating windows" })

-- F4 - next ERROR
vim.keymap.set("n", "<F4>", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { noremap = true, silent = true, desc = "Go to next error" })

-- <C-A> select all text
vim.keymap.set("n", "<C-a>", function()
	vim.cmd "normal! ggVG"
end, { noremap = true, silent = true, desc = "Select all text" })

-------------------------------------------------------------------------------

function nav(vim_direction, wezterm_pane_direction, wezterm_tab_direction)
	-- Try to move in vim first
	local current_win = vim.fn.winnr()
	vim.cmd("wincmd " .. vim_direction)

	-- If we moved in vim, we're done
	if vim.fn.winnr() ~= current_win then
		return
	end

	-- Otherwise use wezterm (async)
	local wezterm_exe = "wezterm.exe"

	if wezterm_tab_direction then
		-- Try tab switch first
		vim.fn.jobstart({ wezterm_exe, "cli", "activate-tab", "--tab-relative", wezterm_tab_direction }, {
			on_exit = function(_, exit_code)
				if exit_code ~= 0 then
					-- Tab switch failed, try pane
					vim.fn.jobstart({ wezterm_exe, "cli", "activate-pane-direction", wezterm_pane_direction })
				end
			end,
		})
	else
		-- Just do pane navigation
		vim.fn.jobstart({ wezterm_exe, "cli", "activate-pane-direction", wezterm_pane_direction })
	end
end

-- ALT + <hjkl> to change vim panes, with fallback to wezterm pane, then to wezterm tab if no pane is found
vim.keymap.set("n", "<M-h>", "<Cmd>lua nav('h', 'Left', '-1')<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-l>", "<Cmd>lua nav('l', 'Right', '1')<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-j>", "<Cmd>lua nav('j', 'Down', nil)<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", "<Cmd>lua nav('k', 'Up', nil)<CR>", { noremap = true, silent = true })

-- Insert mode mappings for ALT + <hjkl>
vim.keymap.set("i", "<M-h>", "<C-\\><C-n><Cmd>lua nav('h', 'Left', '-1')<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<M-l>", "<C-\\><C-n><Cmd>lua nav('l', 'Right', '1')<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<M-j>", "<C-\\><C-n><Cmd>lua nav('j', 'Down', nil)<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<M-k>", "<C-\\><C-n><Cmd>lua nav('k', 'Up', nil)<CR>", { noremap = true, silent = true })

-------------------------------------------------------------------------------

-- Rename
vim.keymap.set(
	"n",
	"<leader>r",
	"<cmd>lua vim.lsp.buf.rename()<CR>",
	{ noremap = true, silent = true, desc = "Rename" }
)

-- Remap : to ;
vim.keymap.set("n", ";", ":", { noremap = true, silent = false })

-- Toggle comment
vim.keymap.set("n", "<C-s>", "gcc", { remap = true, silent = true, desc = "Comment line" })
vim.keymap.set("x", "<C-s>", "gc", { remap = true, silent = true, desc = "Comment selection" })

-- Exits insert mode and returns the cursor to the same position it was before insert mode.
vim.keymap.set("i", "<Esc>", "<Esc>`^", { noremap = true, silent = true })

-- F1 - Rust Clippy fix
vim.keymap.set("n", "<F1>", function()
	vim.cmd "write"
	vim.cmd "silent !cargo clippy --fix --allow-dirty --allow-staged 2>/dev/null"
	vim.cmd "edit"
	-- Delay needed for LSP to recognize external changes
	vim.defer_fn(function()
		vim.cmd "write"
	end, 500)
	print "Clippy fix applied"
end, { noremap = true, silent = true, desc = "Clippy Fix" })

-- Enter in normal mode inserts a new line below with proper indentation
vim.keymap.set("n", "<CR>", "ox<BS><ESC>", {
	noremap = true,
	desc = "󰌑 Insert line below",
})
