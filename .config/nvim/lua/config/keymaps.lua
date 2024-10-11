-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

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

-- clear highlight of search, messages, floating windows
vim.keymap.set({ "n", "i" }, "<Esc>", function()
	vim.cmd [[nohl]] -- clear highlight of search
	vim.cmd [[stopinsert]] -- clear messages (the line below statusline)
	for _, win in ipairs(vim.api.nvim_list_wins()) do -- clear all floating windows
		if vim.api.nvim_win_get_config(win).relative == "win" then
			vim.api.nvim_win_close(win, false)
		end
	end
end, { desc = "Clear highlight of search, messages, floating windows" })

-- F2 - show function signature
vim.keymap.set("n", "<F2>", vim.lsp.buf.signature_help, { noremap = true, silent = true })

-- F4 - Jump to next diagnostic error
vim.keymap.set("n", "<F4>", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { noremap = true, silent = true, desc = "Go to next error" })

-- <C-A> select all text
vim.keymap.set("n", "<C-a>", function()
	vim.cmd "normal! ggVG"
end, { noremap = true, silent = true, desc = "Select all text" })

-------------------------------------------------------------------------------

function nav(vim_direction, wezterm_pane_direction, wezterm_tab_direction)
	local wezterm_exe = "/mnt/c/gdrive/apps/wezterm/wezterm.exe"
	if vim.fn.winnr(vim_direction) ~= vim.fn.winnr() then
		vim.cmd("wincmd " .. vim_direction)
	else
		local pane_result = io.popen(wezterm_exe .. " cli activate-pane-direction " .. wezterm_pane_direction):read "*a"
		if pane_result == "" and wezterm_tab_direction then
			local _ = io.popen(wezterm_exe .. " cli activate-tab --tab-relative " .. wezterm_tab_direction):read "*a"
		end
	end
end

-- ALT+<hjkl> to change vim panes, with fallback to wezterm pane, then to wezterm tab if no pane is found
vim.api.nvim_set_keymap("n", "<M-h>", [[<Cmd>lua nav('h', 'Left', '-1')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-l>", [[<Cmd>lua nav('l', 'Right', '1')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-j>", [[<Cmd>lua nav('j', 'Down', nil)<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-k>", [[<Cmd>lua nav('k', 'Up', nil)<CR>]], { noremap = true, silent = true })

-- Rename
vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true, desc = "Rename" })

-- Toggle comment
vim.keymap.set("n", "<M-w>", "gcc", { remap = true, silent = true, desc = "Comment line" })
vim.keymap.set("x", "<M-w>", "gc", { remap = true, silent = true, desc = "Comment selection" })

-- Exits insert mode and returns the cursor to the same position it was before insert mode.
vim.keymap.set("i", "<Esc>", "<Esc>`^", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "d0", "d^", { noremap = true, silent = true })
