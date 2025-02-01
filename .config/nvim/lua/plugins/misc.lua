return {
	-- Plenary
	{ "nvim-lua/plenary.nvim" },

	-- Markdown View
	{ "OXY2DEV/markview.nvim", lazy = false },

	-- Dressing : For Window UI (Noice, Fugit2, Flutter Tools, Telescope)
	{ "stevearc/dressing.nvim" },

	-- Hints for Keybinds
	{ "folke/which-key.nvim" },

	-- Zen mode
	{ "folke/zen-mode.nvim", vim.keymap.set("n", "<leader>zm", ":ZenMode<CR>", { desc = "Open Zen Mode" }) },

	-- Vim Maximizer
	{ "szw/vim-maximizer", vim.keymap.set("n", "<leader>sm", "<CMD>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" }) },

	-- LazyGit
	{ "kdheepak/lazygit.nvim", vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { desc = "LazyGit" }) },

	-- Neogit
	{ "NeogitOrg/neogit", vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" }) },

	-- Git Diff
	{ "sindrets/diffview.nvim", vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diff View" }) },

	-- Autopairs for Brackets, Brace, Parentheses, Quotations
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },

	-- Git Signs
	{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, config = true },

	-- High-performance color highlighter
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	-- Tmux & split window navigation
	{ "christoomey/vim-tmux-navigator" },

	-- Terminal
	{ "akinsho/toggleterm.nvim", version = "*", config = true },

	-- MD to PDF
	{
		"arminveres/md-pdf.nvim",
		branch = "main", -- you can assume that main is somewhat stable until releases will be made
		lazy = true,
		keys = {
			{
				"<leader>,",
				function()
					require("md-pdf").convert_md_to_pdf()
				end,
				desc = "Markdown preview",
			},
		},
	},

	-- Tailwind Colorizer CMP for Color Highlighting
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("tailwindcss-colorizer-cmp").setup({ color_square_width = 2 })
		end,
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
			vim.keymap.set("n", "<C-c>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("v", "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
			vim.keymap.set("v", "<C-c>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
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

	-- Tailwind Tools
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		lazy = true,
		config = true,
	},

	-- Yazi
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>yz",
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
		},
	},

	-- Marp
	{
		"mpas/marp-nvim",
		config = function()
			vim.keymap.set("n", "<leader>mpt", "<cmd>MarpStart<cr>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>mps", function()
				-- Get the directory of the current file (where theme.css is located)
				local current_dir = vim.fn.expand("%:p:h")

				-- Build the marp command, using full paths for consistency
				local marp_command = "marp --preview --server --theme " .. current_dir .. "/theme.css " .. current_dir

				-- Run the command in the terminal
				vim.cmd("split | terminal " .. marp_command)

				-- Set the height of the terminal split to 10% of the window height
				vim.cmd("resize " .. math.floor(vim.o.lines * 0.15)) -- Set terminal height to 10% of the screen

				-- Automatically close the terminal when it's done
				vim.cmd("autocmd TermClose <buffer> bdelete")
			end, { noremap = true, silent = true, desc = "Open Marp Server" })

			vim.keymap.set("n", "<leader>mpd", function()
				-- Get the current file name
				local file = vim.fn.expand("%")

				-- Open terminal in split and run the marp command
				vim.cmd("split | terminal marp " .. file .. " --pdf --pdf-outlines")

				-- Wait for the terminal to finish, then delete the buffer after the terminal closes
				vim.cmd("autocmd TermClose <buffer> ++nested bd")
			end, { noremap = true, silent = true, desc = "Convert Marp To PDF with Outlines" })

			require("marp").setup({
				port = 8080,
				wait_for_response_timeout = 30,
				wait_for_response_delay = 1,
			})
		end,
	},

	-- Image Clip
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		keys = { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},

	-- HARPOON
	{
		"ThePrimeAgen/harpoon",
		branch = "harpoon2",
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()

			-- REQUIRED
			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():add()
			end, { desc = "Add Window to Harpoon" })
			vim.keymap.set("n", "<leader>hv", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "View Harpoon" })

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-b>", function()
				harpoon:list():prev()
			end, { desc = "Previous Harpoon" })
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():next()
			end, { desc = "Next Harpoon" })
		end,
	},
}
