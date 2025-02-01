return {
	"nvim-lualine/lualine.nvim",

	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")

		local function outputThemeBasedOnMode()
			-- First, Check the OS
			local OS_Name = vim.fn.system("uname"):lower():gsub("%s+$", "")
			local cmd

			if OS_Name == "darwin" then
				cmd = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light") -- Check Dark Mode / Light Mode with Shell Command
				cmd = cmd:gsub("%s+$", "") -- Remove trailing whitespace, including newline
			elseif OS_Name == "linux" then
				cmd = vim.fn.system("gsettings get org.gnome.desktop.interface gtk-theme")
				cmd = cmd:gsub("%s+$", ""):gsub("^[\"'](.*)[\"']$", "%1")
				if cmd == "Pop-dark" then
					cmd = "Dark"
				end
			else
				cmd = "Dark"
			end
			local custom_theme
			if cmd == "Dark" then
				custom_theme = require("lualine.themes.auto")
			else
				custom_theme = require("lualine.themes.ayu_light")
			end
			custom_theme.normal.c.bg = nil
			custom_theme.inactive.c.bg = nil
			return custom_theme
		end

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = true,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		local filename = {
			"filename",
			file_status = true, -- displays file status (readonly status, modified status)
			path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			symbols = { modified = "●", readonly = "[-]", unnamed = "[No Name]", newfile = "[New]" },
		}

		local diff = {
			"diff",
			colored = true,
			symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
		}

		local mode = {
			"mode",
			fmt = function(str)
				return " " .. str
			end,
		}

		local lazy_updates = {
			lazy_status.updates,
			cond = lazy_status.has_updates,
			color = { fg = "#ff9e64" },
		}

		lualine.setup({
			always_divide_middle = false,
			winbar = {
				lualine_y = { diff, diagnostics, { "filetype", icon_only = true }, filename },
			},

			inactive_winbar = {
				lualine_y = { diff, diagnostics, { "filetype", icon_only = true }, filename },
			},

			inactive_sections = { lualine_x = {}, lualine_y = {}, lualine_z = {} },

			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = {},
				lualine_x = { lazy_updates },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},

			options = {
				theme = outputThemeBasedOnMode(),
				globalstatus = false,
				disabled_filetypes = { "neo-tree", "neo-tree-popup", "notify", "alpha", "toggleterm", "dashboard" },
				always_divide_middle = true,
				icons_enabled = true,
				component_separators = { left = "", right = "" },
			},
		})
	end,
}
