require("toggleterm").setup({
	size = 16,
	open_mapping = [[<leader>tt]],
	direction = "horizontal",
	close_on_exit = false,
	hide_numbers = true,
	shade_terminals = false,
	insert_mappings = false,
	terminal_mappings = true,
	persist_size = true,
	persist_mode = true,
	shell = vim.o.shell,
})
