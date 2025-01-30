return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	opts = {
		popup_border_style = "rounded",
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.cmd([[ setlocal relativenumber ]])
				end,
			},
		},
		hide_root_node = true,
		filesystem = {
			filtered_items = {
				visible = true,
				show_hidden_count = true,
				hide_dotfiles = false,
				hide_by_name = {
					".git",
					".DS_Store",
					"thumbs.db",
				},
				never_show = {},
			},
		},
	},

	config = function(_, opts)
		-- MAP CTRL + S & CTRL + / FOR SIDEBAR FILESYSTEM NEOTREE
		vim.keymap.set("n", "<C-s>", ":Neotree left focus<CR>", { desc = "Focus Left Neotree" })
		vim.keymap.set("n", "<C-x>", ":Neotree close<CR>", { desc = "Close Neotree" })
		vim.keymap.set("n", "<leader>nt", ":Neotree float focus<CR>", { desc = "Focus Floating Neotree" })
		vim.keymap.set("n", [[<leader>\]], ":Neotree toggle<CR>", { desc = "Toggle Neotree" })
		require("neo-tree").setup(opts)
	end,
}
