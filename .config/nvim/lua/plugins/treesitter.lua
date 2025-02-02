return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs", -- Sets main module to use for opts
	opts = {
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true, disable = { "dart" } },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},

		ensure_installed = {

			-- WEB FRONTEND
			"astro",
			"css",
			"dart",
			"scss",
			"html",
			"javascript",
			"typescript",
			"tsx",
			"svelte",

			-- BACKEND
			"go",
			"rust",
			"c",
			"c_sharp",
			"java",
			"php",

			-- DATABASE
			"sql",
			"query",

			"terraform",
			"lua",
			"python",
			"rust",
			"regex",
			"json",
			"prisma",
			"graphql",
			"bash",
			"vim",
			"vimdoc",
			"groovy",
			"toml",
			"yaml",
			"make",
			"cmake",
			"http",

			-- SYSTEM
			"dockerfile",

			-- DOCUMENTATION
			"markdown",
			"markdown_inline",

			-- GIT
			"gitignore",
		},
	},
}
