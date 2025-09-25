return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- Ensure Mason binaries are in PATH
		vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

		require("mason").setup({
			ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"clangd",
				"bashls",
				"astro",
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettierd",
				"stylua",
				"eslint_d",
				"clang-format",
				"shfmt",
				"black",
				"isort",
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}
