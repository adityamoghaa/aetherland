-- Small shared helpers used across the hyprland.* config modules

HOME = os.getenv("HOME")

function is_file_exists(path)
	local f = io.open(path, "r")
	if f ~= nil then
		f:close()
		return true
	end
	return false
end
