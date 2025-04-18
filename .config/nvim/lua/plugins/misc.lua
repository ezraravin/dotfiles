return {
	-- Plenary
	{ "nvim-lua/plenary.nvim" },

	-- Dressing : For Window UI (Noice, Fugit2, Flutter Tools, Telescope)
	{ "stevearc/dressing.nvim" },

	-- NUI
	{ "MunifTanjim/nui.nvim" },

	-- Hints for Keybinds
	{ "folke/which-key.nvim", event = "VeryLazy" },

	-- Zen mode
	{ "folke/zen-mode.nvim", vim.keymap.set("n", "<leader>zm", ":ZenMode<CR>", { desc = "Open Zen Mode" }) },

	-- Vim Maximizer
	{ "szw/vim-maximizer", vim.keymap.set("n", "<leader>sm", "<CMD>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" }) },

	-- LazyGit
	{ "kdheepak/lazygit.nvim", vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { desc = "LazyGit" }) },

	-- Autopairs for Brackets, Brace, Parentheses, Quotations
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },

	-- Git Signs
	{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, config = true },

	-- Tmux & split window navigation
	{ "christoomey/vim-tmux-navigator" },

	-- LIVE SERVER
	{
		"barrett-ruth/live-server.nvim",
		build = "pnpm add -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = function()
			require("live-server").setup({
				file = vim.fn.expand("%:p"),
			})
		end,
		vim.keymap.set("n", "<leader>ls", "<CMD>LiveServerStart<CR>", { desc = "Open Live Server" }),
		vim.keymap.set("n", "<leader>lq", "<CMD>LiveServerStop<CR>", { desc = "Terminate Live Server" }),
	},

	-- High-performance color highlighter
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Tailwind Colorizer CMP for Color Highlighting
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("tailwindcss-colorizer-cmp").setup({ color_square_width = 2 })
		end,
	},

	-- Tailwind Tools
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		event = "VeryLazy",
		config = true,
	},

	-- Treesitter Autotag for HTML
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({ opts = { enable_close = true, enable_rename = true } })
		end,
	},

	-- Auto Save Sessions
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = { suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" } },
		vim.keymap.set("n", "<leader>ws", "<CMD>SessionSave<CR>", { desc = "Save session" }),
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},

	-- Web Dev Icons
	{
		"nvim-tree/nvim-web-devicons",
		opts = {
			override_by_extension = {
				["astro"] = {
					icon = "",
					color = "#f1502f",
					name = "Astro",
				},
			},
		},
	},

	-- Comment
	{
		"numToStr/Comment.nvim",
		config = function()
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("v", "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
			vim.keymap.set("v", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
		end,
	},

	-- Refactor
	{
		"ThePrimeagen/refactoring.nvim",
		config = function()
			require("refactoring").setup({
				vim.keymap.set("n", "<leader>re", function()
					require("refactoring").select_refactor({ show_success_message = true })
				end, { desc = "Refactor Code" }),
			})
		end,
	},

	-- Chunking & Indent Line
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({ indent = { enable = true }, chunk = { enable = true }, line_num = { enable = true } })
		end,
	},

	-- Yazi
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		vim.keymap.set("n", "<leader>yz", "<cmd>Yazi<cr>", { desc = "Open Yazi at Current File" }),
	},

	-- LAZYDOCKER
	{
		"crnvl96/lazydocker.nvim",
		event = "VeryLazy",
		opts = {}, -- automatically calls `require("lazydocker").setup()`
		vim.keymap.set("n", "<leader>ld", "<cmd>LazyDocker<cr>", { desc = "Open Lazydocker", noremap = true, silent = true }),
	},

	-- Image Clip
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		keys = { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
}
