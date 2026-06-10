local bufremove = require("mini.bufremove")

bufremove.setup({ silent = true })

vim.keymap.set("n", "<leader>q", function()
	bufremove.delete(0, false)
end, { desc = "Delete buffer" })

vim.keymap.set("n", "<leader>Q", function()
	bufremove.delete(0, true)
end, { desc = "Force delete buffer" })
