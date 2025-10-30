-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- CTRL D/U 10-line jumps
local function scroll_and_center(dir)
	vim.cmd("normal! 10" .. dir)
	local l, ll, hw = vim.fn.line ".", vim.fn.line "$", vim.fn.winheight(0) / 2
	if (dir == "k" and l > hw and l < ll - hw) or (dir == "j" and l + hw <= ll) then
		vim.cmd "normal! zz"
	end
end

vim.keymap.set("n", "<C-u>", function()
	scroll_and_center "k"
end, { silent = true })
vim.keymap.set("n", "<C-d>", function()
	scroll_and_center "j"
end, { silent = true })
vim.keymap.set("n", "<C-f>", "<C-f>zz", { desc = "Scroll down full page and center" })

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

-- F3 - Show signature help if inside function call, otherwise show hover docs
vim.keymap.set("n", "<F3>", function()
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
			if parens > 0 then
				return vim.lsp.buf.signature_help()
			end
		end
	end
	vim.lsp.buf.hover()
end, { noremap = true, silent = true, desc = "LSP documentation" })

-- Close LSP floating windows with Escape (documentation/signature)
vim.keymap.set("n", "<Esc>", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local ok, config = pcall(vim.api.nvim_win_get_config, win)
		if ok and config.relative ~= "" then -- Only floating windows
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
			-- Exclude file explorers and pickers
			if ft ~= "snacks_explorer" and ft ~= "snacks_picker_list" and ft ~= "neo-tree" and ft ~= "NvimTree" then
				pcall(vim.api.nvim_win_close, win, false)
			end
		end
	end
end, { noremap = true, silent = true, desc = "Close LSP floating windows" })

-- F4 - next ERROR
vim.keymap.set("n", "<F4>", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { noremap = true, silent = true, desc = "Go to next error" })

-- <C-A> select all text
vim.keymap.set("n", "<C-a>", function()
	vim.cmd "normal! ggVG"
end, { noremap = true, silent = true, desc = "Select all text" })

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

-- F2 - Toggle inlay hints
vim.keymap.set("n", "<F2>", function()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
	print("Inlay hints " .. (enabled and "disabled" or "enabled"))
end, { noremap = true, silent = true, desc = "Toggle inlay hints" })

-- Enter in normal mode inserts a new line below with proper indentation
vim.keymap.set("n", "<CR>", "ox<BS><ESC>", {
	noremap = true,
	desc = "󰌑 Insert line below",
})

-- Tmux + Neovim seamless navigation
if vim.env.TMUX then
	-- Tell tmux that vim is active
	vim.fn.system("tmux set -p @pane-is-vim 1")
	vim.api.nvim_create_autocmd("VimResume", { command = "silent !tmux set -p @pane-is-vim 1" })
	vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, { command = "silent !tmux set -p -u @pane-is-vim" })

	-- Navigate between vim panes, or tmux windows/panes at edges
	local function navigate(vim_dir, tmux_cmd)
		local win = vim.api.nvim_get_current_win()
		vim.cmd("wincmd " .. vim_dir)
		if vim.api.nvim_get_current_win() == win then
			vim.fn.system("tmux " .. tmux_cmd)
		end
	end

	vim.keymap.set("n", "<M-h>", function() navigate("h", "previous-window") end)
	vim.keymap.set("n", "<M-j>", function() navigate("j", "select-pane -D") end)
	vim.keymap.set("n", "<M-k>", function() navigate("k", "select-pane -U") end)
	vim.keymap.set("n", "<M-l>", function() navigate("l", "next-window") end)
end
