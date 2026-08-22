-- Internal stuff --
require("hyprland.lib")

-- Default configurations --
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

-- Custom configurations --
if is_file_exists(HOME .. "/.config/hypr/modules/execs.lua") then
	require("custom.execs")
end
if is_file_exists(HOME .. "/.config/hypr/modules/general.lua") then
	require("custom.general")
end
if is_file_exists(HOME .. "/.config/hypr/modules/rules.lua") then
	require("custom.rules")
end
if is_file_exists(HOME .. "/.config/hypr/modules/keybinds.lua") then
	require("custom.keybinds")
end

-- nwg-displays support --
if is_file_exists(HOME .. "/.config/hypr/workspaces.lua") then
	require("workspaces")
end
if is_file_exists(HOME .. "/.config/hypr/monitors.lua") then
	require("monitors")
end
