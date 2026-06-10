-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

---- Nvim Tree
require('nvim-tree').setup({
    --open_on_setup = true,
    sync_root_with_cwd = true,
    filters = {
        dotfiles = true,
        custom = { "node_modules" }
    },
    actions = {
        open_file = {
            resize_window = true
        }
    },
    renderer = {
      highlight_opened_files = "icon",
      highlight_git = true
    }
})

vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':NvimTreeRefresh<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFindFile<CR>', {noremap = true})

vim.cmd('hi NvimTreeGitDirty guifg=#f7768e')
vim.cmd('hi NvimTreeWinSeparator guibg=NONE')
