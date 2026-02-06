-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- ============================================================================
-- LSP
-- ============================================================================

-- F1 - Show signature help if inside function call, otherwise show hover docs
vim.keymap.set("n", "<F1>", function()
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
			if parens > 0 then return vim.lsp.buf.signature_help() end
		end
	end
	vim.lsp.buf.hover()
end, { noremap = true, silent = true, desc = "LSP documentation" })

-- F2 - next ERROR
vim.keymap.set(
	"n",
	"<F2>",
	function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
	{ noremap = true, silent = true, desc = "Go to next error" }
)

-- F3 - Show and copy full file path
vim.keymap.set("n", "<F3>", function()
	local path = vim.fn.expand "%:p"
	vim.fn.setreg("+", path)
	vim.notify(path, vim.log.levels.INFO, { title = "File path" })
end, { noremap = true, silent = false, desc = "Copy file path" })

-- F4 - Show and copy folder location
vim.keymap.set("n", "<F4>", function()
	local folder = vim.fn.expand "%:p:h"
	vim.fn.setreg("+", folder)
	vim.notify(folder, vim.log.levels.INFO, { title = "Directory location" })
end, { noremap = true, silent = false, desc = "Copy folder location" })

-- F7 - Rust Clippy fix
vim.keymap.set("n", "<F7>", function()
	vim.cmd "write"
	vim.cmd "silent !cargo clippy --fix --allow-dirty --allow-staged 2>/dev/null"
	vim.cmd "edit"
	-- Delay needed for LSP to recognize external changes
	vim.defer_fn(function() vim.cmd "write" end, 500)
	print "Clippy fix applied"
end, { noremap = true, silent = true, desc = "Clippy Fix" })

-- Rename
vim.keymap.set(
	"n",
	"<leader>r",
	"<cmd>lua vim.lsp.buf.rename()<CR>",
	{ noremap = true, silent = true, desc = "Rename" }
)

-- ============================================================================
-- Editing
-- ============================================================================

-- Fix indentation for i, a, A and I
for _, key in ipairs({ "i", "a", "A", "I" }) do
	vim.keymap.set(
		"n",
		key,
		function() return vim.fn.trim(vim.fn.getline ".") == "" and '"_cc' or key end,
		{ expr = true }
	)
end

-- Exits insert mode and returns the cursor to the same position it was before insert mode.
vim.keymap.set("i", "<Esc>", "<Esc>`^", { noremap = true, silent = true })

-- Enter in normal mode inserts a new line below with proper indentation
vim.keymap.set("n", "<CR>", "ox<BS><ESC>", {
	noremap = true,
	desc = "󰌑 Insert line below",
})

-- Toggle comment
vim.keymap.set("n", "f", "gcc", { remap = true, silent = true, desc = "Comment line" })
vim.keymap.set("x", "f", "gc", { remap = true, silent = true, desc = "Comment selection" })

-- In normal and visual modes, Ctrl+C yanks either the current line (in normal mode)
-- or the selection (in visual mode) to the system clipboard, trimming leading and trailing whitespace
vim.keymap.set({ "n", "x" }, "<C-c>", function()
	vim.cmd('normal! "+' .. (vim.fn.mode() == "n" and "yy" or "y"))
	vim.fn.setreg("+", vim.fn.getreg("+"):match "^%s*(.-)%s*$")
end, { noremap = true, silent = true })

-- In normal mode, Ctrl+V creates a new line, and pastes from the system clipboard
vim.keymap.set("n", "<C-v>", function()
	vim.cmd "normal! $o"
	vim.cmd [[normal! "+p]]
end, { noremap = true, silent = true })

-- <C-A> select all text
vim.keymap.set(
	"n",
	"<C-a>",
	function() vim.cmd "normal! ggVG" end,
	{ noremap = true, silent = true, desc = "Select all text" }
)

-- ============================================================================
-- Navigation
-- ============================================================================

-- Tab to cycle between windows (enforced in all buffers, overrides plugin keymaps)
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = function()
		vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<CR>", { buffer = true, silent = true })
	end,
})

-- Resize windows with Ctrl+Alt+h/l
vim.keymap.set(
	"n",
	"<C-M-h>",
	"<cmd>vertical resize -5<CR>",
	{ noremap = true, silent = true, desc = "Decrease width" }
)
vim.keymap.set(
	"n",
	"<C-M-l>",
	"<cmd>vertical resize +5<CR>",
	{ noremap = true, silent = true, desc = "Increase width" }
)

vim.keymap.set(
	"t",
	"<C-space>",
	function() Snacks.terminal.toggle() end,
	{ noremap = true, silent = true, desc = "Toggle Terminal" }
)
vim.keymap.set(
	"n",
	"<C-space>",
	function() Snacks.terminal.toggle() end,
	{ noremap = true, silent = true, desc = "Toggle Terminal" }
)

-- ============================================================================
-- Misc
-- ============================================================================

-- CTRL D/U 10-line jumps
local function scroll_and_center(dir)
	vim.cmd("normal! 10" .. dir)
	local l, ll, hw = vim.fn.line ".", vim.fn.line "$", vim.fn.winheight(0) / 2
	if (dir == "k" and l > hw and l < ll - hw) or (dir == "j" and l + hw <= ll) then vim.cmd "normal! zz" end
end

vim.keymap.set("n", "<C-u>", function() scroll_and_center "k" end, { silent = true })
vim.keymap.set("n", "<C-d>", function() scroll_and_center "j" end, { silent = true })

-- Remap : to ;
vim.keymap.set("n", ";", ":", { noremap = true, silent = false })

-- Ctrl+Q to save all and quit
vim.keymap.set("n", "<C-q>", "<cmd>wqa!<CR>", { noremap = true, silent = true, desc = "Save all and quit" })
