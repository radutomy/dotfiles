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
	-- local wezterm_exe = "/mnt/c/gdrive/apps/wezterm/wezterm.exe"
	local wezterm_exe = "wezterm.exe"
	if vim.fn.winnr(vim_direction) ~= vim.fn.winnr() then
		vim.cmd("wincmd " .. vim_direction)
	elseif wezterm_tab_direction then
		if io.popen(wezterm_exe .. " cli activate-tab --tab-relative " .. wezterm_tab_direction):read "*a" == "" then
			local _ = io.popen(wezterm_exe .. " cli activate-pane-direction " .. wezterm_pane_direction):read "*a"
		end
	else
		local _ = io.popen(wezterm_exe .. " cli activate-pane-direction " .. wezterm_pane_direction):read "*a"
	end
end

-- CTRL + <hjkl> to change vim panes, with fallback to wezterm pane, then to wezterm tab if no pane is found
vim.keymap.set("n", "<C-h>", "<Cmd>lua nav('h', 'Left', '-1')<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<Cmd>lua nav('l', 'Right', '1')<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<Cmd>lua nav('j', 'Down', nil)<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<Cmd>lua nav('k', 'Up', nil)<CR>", { noremap = true, silent = true })

-- Rename
vim.keymap.set(
	"n",
	"<leader>r",
	"<cmd>lua vim.lsp.buf.rename()<CR>",
	{ noremap = true, silent = true, desc = "Rename" }
)

-- Toggle comment
vim.keymap.set("n", "<C-s>", "gcc", { remap = true, silent = true, desc = "Comment line" })
vim.keymap.set("x", "<C-s>", "gc", { remap = true, silent = true, desc = "Comment selection" })

-- Exits insert mode and returns the cursor to the same position it was before insert mode.
vim.keymap.set("i", "<Esc>", "<Esc>`^", { noremap = true, silent = true })

vim.keymap.set("n", "d0", "d^", { noremap = true, silent = true })

-- Rust format
-- vim.keymap.set("n", "<leader>F", function()
-- vim.cmd "silent !cargo clippy --fix --allow-dirty"
-- end, { remap = false, silent = true, desc = "Clippy Format" })

vim.keymap.set("n", "<CR>", "o<ESC>", {
	noremap = true,
	desc = "󰌑 Insert line below",
})

vim.keymap.set("n", "<S-CR>", "O<ESC>", {
	noremap = true,
	desc = "󰌒 Insert line above",
})
