local wezterm = require("wezterm")
local config = wezterm.config_builder()

------------- Platform Detection -------------
local is_macos = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_windows = wezterm.target_triple:find("windows") ~= nil

-- Set default start program based on OS
if is_macos then
	config.default_prog = { "/usr/local/bin/orb", "-w", "/root", "sh", "-c", "tmux attach 2>/dev/null || tmux" }
elseif is_windows then
	config.default_prog = { "wsl.exe", "~", "-e", "sh", "-c", "tmux attach 2>/dev/null || tmux" }
elseif is_linux then
	config.default_prog = { "/bin/sh", "-c", "tmux attach 2>/dev/null || tmux" }
end

------------- Configuration -------------

config.color_scheme = "Vs Code Dark+ (Gogh)"
config.font = wezterm.font("JetBrains Mono")
config.disable_default_key_bindings = true
config.audible_bell = "Disabled"
config.window_decorations = "RESIZE"
config.font_size = is_macos and 14 or 11
config.warn_about_missing_glyphs = false
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = false
config.default_cursor_style = "SteadyBlock"

config.colors = {
	foreground = "#F2F2F2",
	cursor_bg = "#C44300",
	cursor_border = "#1E1E1E"
}

-- Start maximized
config.initial_rows = 999
config.initial_cols = 999

------------- Keybindings -------------

-- Use CMD on macOS, CTRL on Windows/Linux
local mod = is_macos and "CMD" or "CTRL"

local function copy_or_send_ctrl_c(window, pane)
	local sel = window:get_selection_text_for_pane(pane)
	if sel and sel ~= "" then
		window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
	else
		window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
	end
end

config.keys = {
	{ key = "c", mods = mod, action = wezterm.action_callback(copy_or_send_ctrl_c) },
	{ key = "v", mods = mod, action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "a", mods = mod, action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "=", mods = mod, action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = mod, action = wezterm.action.DecreaseFontSize },
	{ key = "q", mods = mod, action = wezterm.action.QuitApplication },
}

return config
