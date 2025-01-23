local wezterm = require "wezterm"
local mux = wezterm.mux
local config = wezterm.config_builder()
local act = wezterm.action
local cwd_wsl = "/root"

------------- Configuration -------------

config.disable_default_key_bindings = true
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 3000 }
-- config.leader = { key = "F20", timeout_milliseconds = 3000 }

config.audible_bell = "Disabled"
config.default_domain = "WSL:Ubuntu"
config.window_decorations = "RESIZE"
config.color_scheme = "Vs Code Dark+ (Gogh)"
-- config.color_scheme = "Monokai Pro (Gogh)"
-- config.color_scheme = "Monokai Remastered"
-- config.color_scheme = "Solarized Dark Higher Contrast"

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 11
config.warn_about_missing_glyphs = false
config.window_background_opacity = 1
config.tab_and_split_indices_are_zero_based = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false

config.use_fancy_tab_bar = false
config.default_cursor_style = "BlinkingBlock"
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.6
}
config.colors = {
	foreground = "#F2F2F2",
	-- background = '#0C0C0C',
	cursor_bg = "#F21EE0",
	cursor_border = '1E1E1E',
	tab_bar = {
		active_tab = {
			bg_color = '#c44307',
			fg_color = '#F2F2F2',
			intensity = 'Bold'
		},
		inactive_tab = {
			bg_color = '#333333',
			fg_color = 'silver',
		},
	}
}

------------- Create Tabs and Panes -------------

wezterm.on("gui-startup", function(cmd)
    -- Create the first window with the first tab and split into two panes
    local tab_0, pane_0, window_0 = mux.spawn_window {
        workspace = "dev",
        cwd = cwd_wsl
    }
	-- Create first tab with no panes
    tab_0:set_title("ide")
	--pane_0:split { direction = "Bottom", size = 0.5, cwd = cwd_wsl }
    -- Create second tab with two panes
    local tab_1, pane_1 = window_0:spawn_tab { cwd = cwd_wsl }
    tab_1:set_title("main")
    pane_1:split { direction = "Top", size = 0.95, cwd = cwd_wsl }
    -- Create third tab with two panes
    local tab_2, pane_2 = window_0:spawn_tab { cwd = cwd_wsl }
    tab_2:set_title("remote")
    pane_2:split { direction = "Top", size = 0.5, cwd = cwd_wsl }
    ---- Create fourth tab with two panes
    -- local tab_3, pane_3 = window_0:spawn_tab { cwd = cwd_wsl }
    -- tab_3:set_title("aux")
    -- pane_3:split { direction = "Top", size = 0.5, cwd = cwd_wsl }
	-- Create fourth tab with Powershell pane
    local tab_4, pane_4 = window_0:spawn_tab {}
    tab_4:set_title("pwsh")
    pane_4:send_text("pwsh.exe\r")
    -- Set active pane
    pane_0:activate()
    window_0:gui_window():maximize()
end)

------------- Allow movement between VIM and Wezterm Panes -------------

-- if changing the mod_key, also change in: .config/nvim/lua/config/keymaps.lua
local function switch_pane(dir_key, direction)
	local mod_key = 'CTRL'
	return {
		key = dir_key,
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			local process_name = pane:get_foreground_process_name() or ""
			if process_name:find('n?vim') or pane:get_title():find("n?vim") then
				-- Send key with dynamically passed mods
				window:perform_action(act.SendKey({ key = dir_key, mods = mod_key }), pane)
			else
				-- Regular pane direction activation
				local current_pane = pane:pane_id()
				window:perform_action(act.ActivatePaneDirection(direction), pane)
				-- If pane doesn't change, switch tabs
				if current_pane == window:active_pane():pane_id() and (direction == 'Left' or direction == 'Right') then
					window:perform_action(act.ActivateTabRelative(direction == 'Left' and -1 or 1), pane)
				end
			end
		end)
	}
end

------------- Misc -------------

local function bind_copy_key(vim_key, mod_key)
	return {
		key = vim_key,
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			window:perform_action(
				sel and sel ~= '' and wezterm.action { CopyTo = 'ClipboardAndPrimarySelection' } or
				wezterm.action.SendKey { key = vim_key, mods = mod_key }, pane)
		end)
	}
end

------------- Keybindings -------------

config.keys = {
	-- If text is selected, it copies the selection to clipboard. If no text is selected, it sends CTRL + C to the shell
	bind_copy_key('c', "CTRL"),
	{ key = "v", mods = "CTRL",   action = act.PasteFrom "Clipboard" },
	{ key = "p", mods = "LEADER", action = act.ActivateCommandPalette },
	-- Pane Movement
	switch_pane('h', 'Left'),
	switch_pane('l', 'Right'),
	switch_pane('k', 'Up'),
	switch_pane('j', 'Down'),
	{ key = "Tab", mods = "CTRL",       action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	-- Leader key commands
	{ key = "c",   mods = "LEADER",     action = act.CloseCurrentPane { confirm = false } },
	{ key = "x",   mods = "LEADER",     action = act.CloseCurrentTab { confirm = false } },
	{ key = "q",   mods = "LEADER",     action = act.QuitApplication },
	{ key = "v",   mods = "LEADER",     action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
	{ key = "s",   mods = "LEADER",     action = act.SplitVertical { domain = "CurrentPaneDomain" } },
	{ key = "r",   mods = "LEADER",     action = act.ResetTerminal  },
	-- Pane resizing
	{ key = "h",   mods = "CTRL|ALT",   action = act.AdjustPaneSize { "Left", 5 } },
	{ key = "j",   mods = "CTRL|ALT",   action = act.AdjustPaneSize { "Down", 5 } },
	{ key = "k",   mods = "CTRL|ALT",   action = act.AdjustPaneSize { "Up", 5 } },
	{ key = "l",   mods = "CTRL|ALT",   action = act.AdjustPaneSize { "Right", 5 } },
	{ key = '=',   mods = 'CTRL',       action = wezterm.action.IncreaseFontSize },
	{ key = '-',   mods = 'CTRL',       action = wezterm.action.DecreaseFontSize },
}

------------- Status Bar -------------

wezterm.on("update-right-status", function(window, pane)
	local stat = window:active_workspace()
	local stat_color = "#e0af68"
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = "#7dcfff"
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = "#bb9af7"
	end

	local function replace_home_with_tilde(path)
		local home = os.getenv("HOME") or "/root" -- Fallback to "/root" if HOME is not set
		if path:sub(1, #home) == home then
			return "~" .. path:sub(#home + 1)
		end
		return path
	end

	-- Current working directory
	local cwd = pane:get_current_working_dir()
	cwd = cwd and replace_home_with_tilde(cwd.file_path) or ""

	-- Time
	local time = wezterm.strftime("%H:%M")

	-- Right status
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#7CB342" } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Foreground = { Color = 'silver' } },
		{ Text = " | " },
		{ Foreground = { Color = stat_color } },
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Foreground = { Color = 'silver' } },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = "  " }
	}))
end)

return config
