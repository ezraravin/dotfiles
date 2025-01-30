local wezterm = require("wezterm")

local act = wezterm.action

local M = {}

function M.setup(config)
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
	config.keys = {
		{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
		{ key = "m", mods = "CMD", action = act.DisableDefaultAssignment },
		{ key = "t", mods = "CMD", action = act.DisableDefaultAssignment },
		-- Enable CMD+S for Save in Terminal
		{ key = "s", mods = "CMD", action = act.SendKey({ key = "s", mods = "META" }) },
		{ key = "w", mods = "CMD", action = act.SendKey({ key = "w", mods = "META" }) },
		-- Split Pane
		{ mods = "LEADER", key = "\\", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ mods = "LEADER", key = "-", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		-- Maximize Pane
		{ mods = "LEADER", key = "m", action = act.TogglePaneZoomState },
		-- Switch Pane
		{ mods = "LEADER", key = "Space", action = act.RotatePanes("Clockwise") },
		-- show the pane selection mode, but have it swap the active and selected panes
		{ mods = "LEADER", key = "0", action = act.PaneSelect({ mode = "SwapWithActive" }) },
		-- Activate Copy Mode
		{ mods = "LEADER", key = "Enter", action = act.ActivateCopyMode },
		-- Adjust Pane Size
		{ key = "h", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "l", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "j", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "k", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "m", mods = "LEADER", action = act.TogglePaneZoomState },
		-- Close Current Pane
		{ key = "w", mods = "CTRL", action = act.CloseCurrentPane({ confirm = true }) },
		-- Switch Pane
		{ mods = "LEADER", key = "0", action = act.PaneSelect({ mode = "SwapWithActive" }) },
	}
end

return M

