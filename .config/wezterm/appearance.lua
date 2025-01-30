local wezterm = require("wezterm")

local M = {}

-- Auto Dark/Light Mode
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

-- Catppuccin
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

function M.setup(config)
	-- Window Decorations
	config.window_decorations = "RESIZE"

	-- Fonts
	config.font = wezterm.font_with_fallback({ "JetBrains Mono", "JetBrainsMono Nerd Font" })
	config.font_size = 13.0

	-- Color
	config.term = "xterm-256color"

	-- Tab Bar
	config.enable_tab_bar = false

	-- Cursor Style
	config.default_cursor_style = "BlinkingBar"

	-- Color Scheme
	config.color_scheme = scheme_for_appearance(get_appearance())

	-- Padding
	config.window_padding = { left = "0px", right = "0px", top = "0px", bottom = "64px" }
end

return M

