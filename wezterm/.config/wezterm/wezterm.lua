local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_scroll_bar = false
config.enable_wayland = true
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 60
config.scrollback_lines = 10000

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font({
	family = "JetBrains Mono",
	weight = "Regular",
	harfbuzz_features = { "calt=1", "clig=1", "liga=1" }, -- Enable ligatures
})
config.font_size = 14.0
config.line_height = 1.1
config.cell_width = 1.0

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 700
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.window_background_opacity = 0.92
config.macos_window_background_blur = 64

config.window_padding = {
	left = 4,
	right = 4,
	top = 4,
	bottom = 4,
}

config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 32

config.colors = {
	tab_bar = {
		background = "#11111b",
		active_tab = {
			bg_color = "#cba6f7",
			fg_color = "#11111b",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#181825",
			fg_color = "#cdd6f4",
		},
		inactive_tab_hover = {
			bg_color = "#313244",
			fg_color = "#cdd6f4",
		},
		new_tab = {
			bg_color = "#181825",
			fg_color = "#cdd6f4",
		},
		new_tab_hover = {
			bg_color = "#313244",
			fg_color = "#cdd6f4",
		},
	},
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "|", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	{ key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Right") },

	{ key = "h", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },

	-- Close pane
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },

	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },

	{ key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },

	{ key = "q", mods = "CTRL", action = wezterm.action.ToggleFullScreen },

	{ key = "'", mods = "CTRL", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },

	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

	{ key = "=", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CTRL|SHIFT", action = wezterm.action.ResetFontSize },

	{ key = "f", mods = "LEADER", action = wezterm.action.ShowLauncher },

	{
		key = "o",
		mods = "LEADER",
		action = wezterm.action.QuickSelectArgs({
			patterns = { "https?://\\S+" },
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.open_with(url)
			end),
		}),
	},

	{ key = "/", mods = "LEADER", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

config.adjust_window_size_when_changing_font_size = false

config.quick_select_patterns = {
	"https?://\\S+",
	-- Match file paths
	"/[\\w/.-]+",
	"~/[\\w/.-]+",
	-- Match git SHAs
	"[0-9a-f]{7,40}",
	-- Match UUIDs
	"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
}

config.hyperlink_rules = {
	{
		regex = "\\b\\w+://[\\w.-]+\\S*\\b",
		format = "$0",
	},
	-- GitHub-style issues/PRs
	{
		regex = "\\b[a-zA-Z0-9-_]+/[a-zA-Z0-9-_]+#\\d+\\b",
		format = "https://github.com/$0",
	},
	-- File paths (absolute)
	{
		regex = "\\b/[\\w/.-]+",
		format = "file://$0",
	},
}

config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nvim",
	"vim",
}

return config
