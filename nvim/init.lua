-- Mappings
vim.g.mapleader = ' '
vim.keymap.set('n', '<Leader>e', '<cmd>NvimTreeToggle<CR>')
--vim.keymap.set('n', '<Leader>.i', '<cmd>PlugInstall<CR>')
--vim.keymap.set('n', '<Leader>.u', '<cmd>PlugUpdate<CR>')
--vim.keymap.set('n', '<Leader>.s', '<cmd>source $MYVIMRC<CR>')

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
call plug#end()
]])

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
	P = {
		u = { "<cmd>PlugUpdate<CR>" },
		s = { "<cmd>source $MYVIMRC<CR>" }
	}
}, {})
vim.opt.timeoutlen=500

-- Disable netrw since we're using nvim-tree.
vim.g.loaded_netr = 1
vim.g.loaded_netrwPlugin = 1

-- Colourful
vim.opt.termguicolors = true

-- Other config to make things less horrible
vim.opt.rnu = true
