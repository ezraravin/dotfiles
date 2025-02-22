return {
	"arminveres/md-pdf.nvim",
	branch = "main",
	lazy = true,
	keys = {
		{
			"<leader>mpv",
			function()
				require("md-pdf").convert_md_to_pdf()
			end,
			desc = "Markdown preview",
		},
	},
	opts = {
		margins = "1.5cm",
		highlight = "tango",
		toc = true,
		output_path = "",
	},
}
