return {
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
}
