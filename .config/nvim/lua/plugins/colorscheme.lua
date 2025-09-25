return {
	-- Configure Catppuccin
	{
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
			require("catppuccin").setup({
				flavour = "mocha",
			})
		end,
	},
}
