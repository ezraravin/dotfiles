return {
	"akinsho/bufferline.nvim",
	version = "*",
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({

			options = {
				mode = "buffers",
				mouse_command = "<CMD>bd%d<CR>",
				path_components = 1,

				-- Diagnostics
				diagnostics = "nvim_lsp",
				diagnostics_update_on_event = true, -- use nvim's diagnostic handler

				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local sym = e == "error" and " " or (e == "warning" and " " or " ")
						s = s .. sym .. n
					end
					return s
				end,
				buffer_close_icon = "✗",
				left_trunc_marker = "",
				right_trunc_marker = "",
				separator_style = "slant",
			},
		})
	end,
}
