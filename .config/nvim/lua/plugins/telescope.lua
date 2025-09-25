return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			require("telescope").load_extension("flutter")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
			})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Fuzzy find buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Fuzzy find help tags" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find string in cwd" })
			vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		end,
	},
}
