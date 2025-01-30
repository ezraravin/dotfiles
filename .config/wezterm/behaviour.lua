local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local M = {}

function M.setup(config)
	config.automatically_reload_config = true
	config.window_close_confirmation = "NeverPrompt"
end

return M

