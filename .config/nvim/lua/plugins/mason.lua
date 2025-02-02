return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({})

		require("mason-lspconfig").setup({
			ensure_installed = { "html", "cssls", "tailwindcss", "lua_ls", "ts_ls", "astro", "svelte", "clangd", "dockerls", "emmet_ls" },
		})

		require("mason-tool-installer").setup({
			ensure_installed = { "stylua", "prettierd" },
		})
	end,
}
