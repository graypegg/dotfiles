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
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
	Plug 'neovim/nvim-lspconfig'

	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'nvim-tree/nvim-tree.lua'

	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

	Plug 'folke/which-key.nvim'

	Plug 'bling/vim-bufferline'

	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

	Plug 'nvim-lua/plenary.nvim'

	Plug 'ThePrimeagen/refactoring.nvim'

	Plug 'christoomey/vim-tmux-navigator'

	Plug 'glepnir/zephyr-nvim'

	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
call plug#end()
]])

-- If everything is installed, set up config.
-- Gives you a chance to do a :PlugInstall x2 to get everything working. (Two times because of dependancies)
if vim.fn.has_key(vim.g['plugs'], 'vim-airline') == 1 then
	-- Set colour scheme
	vim.cmd[[colorscheme zephyr]]
	vim.g.airline_theme = 'jet'

	-- Colourful
	vim.opt.termguicolors = true

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

	-- Set up LSPs
	require'lspconfig'.tsserver.setup {}
	require'lspconfig'.solargraph.setup {}
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

	-- Use LspAttach autocommand to only map the following keys
	-- after the language server attaches to the current buffer
	vim.api.nvim_create_autocmd('LspAttach', {
	  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	  callback = function(ev)
	    -- Enable completion triggered by <c-x><c-o>
	    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

	    -- Buffer local mappings.
	    -- See `:help vim.lsp.*` for documentation on any of the below functions
	    local opts = { buffer = ev.buf }
	    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
	    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	    vim.keymap.set('n', '<leader>f', function()
	      vim.lsp.buf.format { async = true }
	    end, opts)
	  end,
	})

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
			b = "Jump",
			["<leader>"] = "Search"
		},
		f = "Format",
		rn = "Rename",
		a = "Code Action",
		s = {
			name = "Split Buffers",
			v = "Vertical",
			h = "Horizontal"
		},
		["<leader>"] = {
			name = "Search",
			f = "Find Files",
			g = "Live Grep",
			b = "Buffers",
			h = "Help"
		}
	}, { prefix = '<Leader>'})
	wk.register({
		gd = "Go to Definition",
		gD = "Go to Declaration",
		gi = "Go to Implemention",
		gr = "Go to Reference",
	})

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

	-- Set up telescope
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader><leader>f', builtin.find_files, {})
	vim.keymap.set('n', '<leader><leader>g', builtin.live_grep, {})
	vim.keymap.set('n', '<leader><leader>b', builtin.buffers, {})
	vim.keymap.set('n', 'b<leader>', builtin.buffers, {})
	vim.keymap.set('n', '<leader><leader>h', builtin.help_tags, {})

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

	-- Other config to make things less horrible
	vim.opt.rnu = true
end
