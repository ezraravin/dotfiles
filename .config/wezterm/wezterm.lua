local wezterm = require("wezterm")
local appearance = require("appearance")
local behaviour = require("behaviour")
local keymap = require("keymap")
local config = wezterm.config_builder()

appearance.setup(config)
behaviour.setup(config)
keymap.setup(config)
return config

