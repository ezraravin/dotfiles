return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- Common capabilities
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostic signs
		for type, icon in pairs({ Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }) do
			vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
		end

		-- Keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				local mappings = {
					{ "gR", "<cmd>Telescope lsp_references<CR>", desc = "Show LSP references" },
					{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
					{ "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "Show LSP definitions" },
					{ "gi", "<cmd>Telescope lsp_implementations<CR>", desc = "Show LSP implementations" },
					{ "gt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Show LSP type definitions" },
					{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code actions", mode = { "n", "v" } },
					{ "<leader>rn", vim.lsp.buf.rename, desc = "Smart rename" },
					{ "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Buffer diagnostics" },
					{ "<leader>d", vim.diagnostic.open_float, desc = "Line diagnostics" },
					{ "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
					{ "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
					{ "K", vim.lsp.buf.hover, desc = "Documentation hover" },
					{ "<leader>rs", "<cmd>LspRestart<CR>", desc = "Restart LSP" },
				}

				for _, map in ipairs(mappings) do
					keymap.set(map.mode or "n", map[1], map[2], vim.tbl_extend("force", opts, { desc = map.desc }))
				end
			end,
		})

		-- Common filetype groups
		local web_ft = { "html", "typescriptreact", "javascriptreact", "svelte" }

		mason_lspconfig.setup_handlers({
			["svelte"] = function()
				lspconfig.svelte.setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["graphql"] = function()
				lspconfig.graphql.setup({ capabilities = capabilities, filetypes = vim.list_extend(web_ft, { "graphql", "gql" }) })
			end,
			["emmet_ls"] = function()
				lspconfig.emmet_ls.setup({ capabilities = capabilities, filetypes = vim.list_extend(web_ft, { "css", "sass", "scss", "less" }) })
			end,
			["pyright"] = function()
				lspconfig.pyright.setup({
					capabilities = capabilities,
					settings = {
						pyright = { autoImportCompletion = true },
						python = {
							analysis = {
								typeCheckingMode = "off",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				})
			end,
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							completion = { callSnippet = "Replace" },
							workspace = { checkThirdParty = false },
						},
					},
				})
			end,
			function(server) -- Default handler
				lspconfig[server].setup({ capabilities = capabilities })
			end,
		})
	end,
}
