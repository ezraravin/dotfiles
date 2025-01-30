return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
		})

		require("mason-lspconfig").setup({
			ensure_installed = { "html", "cssls", "tailwindcss", "lua_ls", "ts_ls", "astro", "svelte" },
		})

		require("mason-tool-installer").setup({
			ensure_installed = { "stylua", "eslint-lsp", "prettierd" },
		})
	end,
}
