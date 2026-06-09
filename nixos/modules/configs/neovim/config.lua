vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.termguicolors = true

vim.cmd('colorscheme tokyonight-storm')

vim.opt.backup = true
vim.opt.wb = true
vim.opt.swapfile = true
vim.opt.undofile = true

local state_dir = vim.env.XDG_STATE_HOME or vim.fn.expand("~/.local/state")
vim.opt.backupdir = {state_dir .. "/nvim/backup//"}
vim.opt.undodir = {state_dir .. "/nvim/undo//"}
vim.opt.directory = {state_dir .. "/nvim/swap//"}

vim.opt.clipboard = "unnamedplus"

---- Text, Tabs and Indentation
vim.opt.listchars = {tab = '|·'}
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.splitright = true;

vim.opt.completeopt = {'menuone', 'noselect'}
vim.opt.cursorline = true
vim.opt.lazyredraw = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.magic = true
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 100
vim.opt.laststatus = 3
vim.opt.diffopt = 'vertical'

--- Keybinds
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', ':noh<CR><CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('', '<C-j>', '<C-W>j', {noremap = true})
vim.api.nvim_set_keymap('', '<C-k>', '<C-W>k', {noremap = true})
vim.api.nvim_set_keymap('', '<C-h>', '<C-W>h', {noremap = true})
vim.api.nvim_set_keymap('', '<C-l>', '<C-W>l', {noremap = true})

vim.api.nvim_set_keymap('', ';', ':', {noremap = true})
