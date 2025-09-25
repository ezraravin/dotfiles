return {
	"nvim-flutter/flutter-tools.nvim",
	lazy = false,
	config = function()
		require("flutter-tools").setup({
			ui = {
				border = "rounded",
				notification_style = "native",
			},
			decorations = {
				statusline = {
					app_version = true, -- Show pubspec version
					device = true, -- Show connected device
					project_config = true, -- Show build config
				},
			},
			widget_guides = {
				enabled = true, -- Visual widget hierarchy guides
			},
			closing_tags = {
				enabled = true, -- Auto-close widget tags
				highlight = "ErrorMsg", -- Visual highlight
				prefix = ">", -- Closing tag indicator
				priority = 10,
			},
			dev_log = {
				enabled = true, -- Enhanced dev logs
				notify_errors = true, -- Error notifications
				open_cmd = "15split", -- Open in bottom split
				focus_on_open = true, -- Auto-focus log window
			},
			outline = {
				open_cmd = "80vnew", -- Open in vertical split
				auto_open = true, -- Auto-show widget tree
			},
			lsp = {
				color = {
					enabled = true, -- Full color highlighting
					background = true, -- Background colors
					foreground = true, -- Text colors
					virtual_text = true, -- Color indicators
					virtual_text_str = "■", -- Indicator symbol
					background_color = { -- Fallback dark color
						r = 30,
						g = 30,
						b = 46,
						a = 1,
					},
					-- Robust color value handler
					on_color = function(color)
						if not color then
							return nil
						end
						return {
							r = math.floor((color.red or 0) * 255),
							g = math.floor((color.green or 0) * 255),
							b = math.floor((color.blue or 0) * 255),
							a = color.alpha or 1,
						}
					end,
				},
				settings = {
					showTodos = true,
					completeFunctionCalls = true,
					renameFilesWithClasses = "prompt",
					enableSnippets = true,
					updateImportsOnRename = true,
				},
			},
		})

		-- Enhanced Keymaps
		vim.keymap.set("n", "<leader>flr", "<cmd>Telescope flutter commands<CR>", { desc = "Flutter commands" })
		vim.keymap.set("n", "<leader>flv", "<cmd>Telescope flutter fvm<CR>", { desc = "Flutter versions" })
		vim.keymap.set("n", "<leader>flo", "<cmd>FlutterOutlineToggle<CR>", { desc = "Toggle outline" })
		vim.keymap.set("n", "<leader>fll", "<cmd>FlutterLog<CR>", { desc = "View logs" })
		vim.keymap.set("n", "<leader>flc", "<cmd>FlutterCopyProfilerUrl<CR>", { desc = "Copy profiler URL" })
		vim.keymap.set("n", "<leader>flt", "<cmd>FlutterReload<CR>", { desc = "Hot reload" })
		vim.keymap.set("n", "<leader>flT", "<cmd>FlutterRestart<CR>", { desc = "Hot restart" })
	end,
}
