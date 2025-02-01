return {
	-- Noice
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"rcarriga/nvim-notify",
			{
				"echasnovski/mini.icons",
				version = false,
			},
		},
		config = function()
			require("noice").setup({
				messages = {
					-- NOTE: If you enable messages, then the cmdline is enabled automatically.
					-- This is a current Neovim limitation.
					enabled = true, -- enables the Noice messages UI
					-- CHANGE TO MINI, ANNOYING AF MF
					view = "mini", -- default view for messages
					view_error = "notify", -- view for errors
					view_warn = "notify", -- view for warnings
					view_history = "messages", -- view for :messages
					view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
				},
			})
			require("notify").setup({
				top_down = false,
				stages = "slide",
			})
		end,
	},
	-- Trouble
	"folke/trouble.nvim",
	opts = {
		focus = true,
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>td",
			"<cmd>Trouble diagnostics toggle<CR>",
			desc = "Open trouble workspace diagnostics",
		},
		{
			"<leader>td",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Open trouble document diagnostics",
		},
		{ "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
		{ "<leader>tt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
	},
}
