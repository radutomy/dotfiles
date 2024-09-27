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
