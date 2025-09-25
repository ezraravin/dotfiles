return {
	"nvim-lualine/lualine.nvim",

	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")

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

		local diff = {
			"diff",
			colored = true,
			symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
		}

		local lazy_updates = {
			lazy_status.updates,
			cond = lazy_status.has_updates,
			color = { fg = "#ff9e64" },
		}

		lualine.setup({
			always_divide_middle = false,
			winbar = {},

			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			inactive_sections = {
				lualine_a = { { "filetype", icon_only = true }, "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			sections = {
				lualine_a = { { "mode", separator = { left = "" } } },
				lualine_b = { "branch" },
				lualine_c = { { "filetype", icon_only = true }, "filename" },
				lualine_x = { lazy_updates },
				lualine_y = { diff, diagnostics },
				lualine_z = { "progress", { "location", separator = { right = "" } } },
			},

			options = {
				theme = require("lualine.themes.auto"),
				globalstatus = false,
				disabled_filetypes = { "neo-tree", "neo-tree-popup", "notify", "alpha", "toggleterm", "dashboard" },
				always_divide_middle = true,
				icons_enabled = true,
				section_separators = { left = "", right = "" },
			},
		})
	end,
}
