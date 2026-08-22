require("hyprland.lib")

-- Helper: define workspace keys 1–9 and 0→10
local function bind_workspace_keys()
	local keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
	local workspaces = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

	for i = 1, 10 do
		local ws = workspaces[i]

		-- Focus workspace
		hl.bind("SUPER + " .. keys[i], hl.dsp.focus({ workspace = ws }), { description = "Workspace: Focus " .. ws })

		-- Move window to workspace
		hl.bind(
			"SUPER + SHIFT + " .. keys[i],
			hl.dsp.window.move({ workspace = ws, follow = false }),
			{ description = "Window: Send to workspace " .. ws }
		)
	end
end

-- Main application and utility binds (from keybind.conf)
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("wezterm"), { description = "App: Terminal" })
hl.bind(
	"SUPER + T",
	hl.dsp.exec_cmd("wezterm start -- tmux new-session -A -s main"),
	{ description = "App: Terminal (tmux)" }
)
hl.bind("SUPER + W", hl.dsp.exec_cmd("firefox"), { description = "App: Browser" })
hl.bind("SUPER + A", hl.dsp.exec_cmd("google-chrome-stable"), { description = "App: Chrome" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("$HOME/.local/bin/rofi/launcher"), { description = "App: Launcher" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("[float; center] wezterm -e yazi"), { description = "App: File manager (yazi)" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Toggle floating" })
hl.bind(
	"SUPER + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Window: Toggle fullscreen" }
)
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("$HOME/.local/bin/rofi/emoji"), { description = "App: Emoji picker" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Utilities: Color picker" })
hl.bind(
	"SUPER + SHIFT + V",
	hl.dsp.exec_cmd("$HOME/.local/bin/rofi/clipboard"),
	{ description = "App: Clipboard history" }
)
hl.bind("SUPER + X", hl.dsp.exec_cmd("$HOME/.local/bin/rofi/powermenu"), { description = "App: Power menu" })
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"), { description = "Session: Lock" })
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("$HOME/.local/bin/reload"), { description = "Shell: Reload config" })

-- Media and brightness (from keybind.conf)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("$HOME/.local/bin/brightness up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("$HOME/.local/bin/brightness down"), { repeating = true })
hl.bind("XF86Messenger", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86Go", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("Cancel", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("$HOME/.local/bin/volume up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("$HOME/.local/bin/volume down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("$HOME/.local/bin/volume mute"))

-- Screenshots
hl.bind(
	"Print",
	hl.dsp.exec_cmd("$HOME/.local/bin/screenshot full"),
	{ description = "Utilities: Screenshot full" }
)
hl.bind(
	"SHIFT + Print",
	hl.dsp.exec_cmd("$HOME/.local/bin/screenshot region"),
	{ description = "Utilities: Screenshot region" }
)

-- Focus with mainMod + hjkl (vim-style)
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }), { description = "Window: Focus left" })
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }), { description = "Window: Focus right" })
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }), { description = "Window: Focus up" })
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }), { description = "Window: Focus down" })

-- Move windows with mainMod + SHIFT + hjkl
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "left" }), { description = "Window: Move left" })
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "right" }), { description = "Window: Move right" })
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "up" }), { description = "Window: Move up" })
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "down" }), { description = "Window: Move down" })

-- Resize windows with mainMod + CONTROL + hjkl
hl.bind(
	"SUPER + CONTROL + h",
	hl.dsp.window.resize({ x = -40, y = 0 }),
	{ description = "Window: Resize left", repeating = true }
)
hl.bind(
	"SUPER + CONTROL + l",
	hl.dsp.window.resize({ x = 40, y = 0 }),
	{ description = "Window: Resize right", repeating = true }
)
hl.bind(
	"SUPER + CONTROL + k",
	hl.dsp.window.resize({ x = 0, y = -40 }),
	{ description = "Window: Resize up", repeating = true }
)
hl.bind(
	"SUPER + CONTROL + j",
	hl.dsp.window.resize({ x = 0, y = 40 }),
	{ description = "Window: Resize down", repeating = true }
)

-- Center floating window
hl.bind("SUPER + c", hl.dsp.window.center(), { description = "Window: Center floating" })

-- Workspace switching
bind_workspace_keys()

-- Switch to most recent workspace
hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "previous" }), { description = "Workspace: Focus previous" })

-- Special workspace (scratchpad)
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"), { description = "Workspace: Toggle scratchpad" })
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.window.move({ workspace = "special:magic", follow = false }),
	{ description = "Window: Send to scratchpad" }
)

-- Scroll through workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Workspace: Focus next" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Workspace: Focus previous" })

-- Move/resize windows with mainMod + mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move with mouse" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize with mouse" })
