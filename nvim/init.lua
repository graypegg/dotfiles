-- Mappings
vim.g.mapleader = ' '
vim.keymap.set('n', '<Leader>e', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<Leader>Pi', '<cmd>PlugInstall<CR>')
vim.keymap.set('n', '<Leader>Pu', '<cmd>PlugUpdate<CR>')
vim.keymap.set('n', '<Leader>Ps', '<cmd>source $MYVIMRC<CR>')

vim.keymap.set('n', '<Leader>bn', '<cmd>:bnext<CR>')
vim.keymap.set('n', '<Leader>bv', '<cmd>:blast<CR>')
vim.keymap.set('n', '<Leader>bc', '<cmd>:bdelete<CR>')
vim.keymap.set('n', '<Leader>bb', ':b ')

vim.keymap.set('n', '<Leader>sv', ':vert sb ')
vim.keymap.set('n', '<Leader>sh', ':sb ')

vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')

-- Vim Plug
vim.cmd([[
call plug#begin()
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'nvim-tree/nvim-tree.lua'

	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

	Plug 'folke/which-key.nvim'

	Plug 'bling/vim-bufferline'

	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

	Plug 'nvim-lua/plenary.nvim'

	Plug 'ThePrimeagen/refactoring.nvim'

	Plug 'christoomey/vim-tmux-navigator'
call plug#end()
]])

-- Set colour scheme
vim.cmd[[colorscheme tokyonight-moon]]

-- Set up nvim-tree
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})

-- Set up tree sitter
require'nvim-treesitter.configs'.setup {
	ensure_installed = { 'ruby', 'javascript', 'typescript', 'lua' },
}

-- Set up Airline
vim.g.airline_theme = 'deus'

-- Set up Which Key
local wk = require("which-key")
wk.register({
	P = { name = "Misc" },
	e = "Explore",
	r = {
		name = "Refactor",
		i = "Inline Variable",
		b = "Extract Block",
	},
	b = {
		name = "Buffers",
		n = "Next",
		v = "Prev",
		c = "Close",
		b = "Jump"
	},
	s = {
		name = "Split Buffers",
		v = "Vertical",
		h = "Horizontal"
	}
}, { prefix = '<Leader>'})

wk.register({
	r = {
		name = "Refactor",
		e = "Extract Function",
		f = "Extract Function to File",
		v = "Extract Variable",
		i = "Inline Variable"
	}
}, { mode = 'v', prefix = '<Leader>'})
vim.opt.timeoutlen=500

-- Set up refactoring tools
require('refactoring').setup({})

-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], {noremap = true, silent = true, expr = false})

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- Disable netrw since we're using nvim-tree.
vim.g.loaded_netr = 1
vim.g.loaded_netrwPlugin = 1

-- Colourful
vim.opt.termguicolors = true

-- Other config to make things less horrible
vim.opt.rnu = true
