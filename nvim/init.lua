-- Mappings
vim.g.mapleader = ' '
vim.keymap.set('n', '<Leader>e', '<cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<Leader>Pi', '<cmd>PlugInstall<CR>')
vim.keymap.set('n', '<Leader>Pu', '<cmd>PlugUpdate<CR>')
vim.keymap.set('n', '<Leader>PP', '<cmd>call plug#load("vimnuance")<CR>')
vim.keymap.set('n', '<Leader>Ps', '<cmd>source $MYVIMRC<CR>')

vim.keymap.set('n', '<Leader>bn', '<cmd>:bnext<CR>')
vim.keymap.set('n', '<Leader>bv', '<cmd>:blast<CR>')
vim.keymap.set('n', '<Leader>bc', '<cmd>:bdelete<CR>')
vim.keymap.set('n', '<Leader>bC', '<cmd>:bdelete!<CR>')
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

		Plug 'kosayoda/nvim-lightbulb'
		Plug 'antoinemadec/FixCursorHold.nvim'
		
		Plug 'vim-crystal/vim-crystal'

		Plug 'vim-airline/vim-airline'
		Plug 'vim-airline/vim-airline-themes'

		Plug 'folke/which-key.nvim'

		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

		Plug 'nvim-lua/plenary.nvim'

		Plug 'ThePrimeagen/refactoring.nvim'

		Plug 'christoomey/vim-tmux-navigator'

		Plug 'glepnir/zephyr-nvim'

		Plug 'tpope/vim-surround'
		Plug 'tpope/vim-commentary'

		Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }

		Plug 'neoclide/coc.nvim', {'branch': 'release'}

		Plug 'nvim-orgmode/orgmode'
	call plug#end()
]])

-- If everything is installed, set up config.
-- Gives you a chance to do a :PlugInstall x2 to get everything working. (Two times because of dependancies)
if vim.fn.has_key(vim.g['plugs'], 'vim-airline') == 1 then
	-- Set colour scheme
	vim.cmd[[colorscheme zephyr]]
	vim.g.airline_theme = 'deus'
	vim.cmd([[
		let g:airline_powerline_fonts = 1
		let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
		let g:airline#extensions#tabline#enabled = 1
	]])

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
	require('orgmode').setup_ts_grammar()
	require'nvim-treesitter.configs'.setup {
		ensure_installed = { 'ruby', 'javascript', 'typescript', 'lua', 'org' },
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = {'org'},
		}
	}

	-- set up orgmode
	require('orgmode').setup({
		org_agenda_files = {'~/gray.org'},
		org_default_notes_file = '~/gray.org',
	})

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
	    vim.keymap.set({ 'n', 'v' }, '<leader>aa', vim.lsp.buf.code_action, opts)
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
			C = "Close!",
			b = "Jump",
			["<leader>"] = "Search"
		},
		f = "Format",
		rn = "Rename",
		a = {
			name = "Code Action",
			a = "LSP Action"
		},
		o = { name = "org mode" },
		q = 'which_key_ignore',
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
			h = "Help",
		}
	}, { prefix = '<Leader>'})
	wk.register({
		gd = "Go to Definition",
		gD = "Go to Declaration",
		gi = "Go to Implemention",
		gr = "Go to Reference",
		cs = "Change Surround",
		ds = "Delete Surround"
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

	-- Coc
	local keyset = vim.keymap.set
	
	-- Autocomplete
	function _G.check_back_space()
	    local col = vim.fn.col('.') - 1
	    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
	end

	-- Use Tab for trigger completion with characters ahead and navigate
	-- NOTE: There's always a completion item selected by default, you may want to enable
	-- no select by setting `"suggest.noselect": true` in your configuration file
	-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
	-- other plugins before putting this into your config
	local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
	keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
	keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

	-- Make <CR> to accept selected completion item or notify coc.nvim to format
	-- <C-g>u breaks current undo, please make your own choice
	keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

	-- Use <c-j> to trigger snippets
	keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
	-- Use <c-space> to trigger completion
	keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

	-- Use `[g` and `]g` to navigate diagnostics
	-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
	keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
	keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

	-- GoTo code navigation
	keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
	keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
	keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
	keyset("n", "gr", "<Plug>(coc-references)", {silent = true})


	-- Use K to show documentation in preview window
	function _G.show_docs()
	    local cw = vim.fn.expand('<cword>')
	    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	    elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	    else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	    end
	end
	keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


	-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
	vim.api.nvim_create_augroup("CocGroup", {})
	vim.api.nvim_create_autocmd("CursorHold", {
	    group = "CocGroup",
	    command = "silent call CocActionAsync('highlight')",
	    desc = "Highlight symbol under cursor on CursorHold"
	})


	-- Symbol renaming
	keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


	-- Formatting selected code
	keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
	keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


	-- Setup formatexpr specified filetype(s)
	vim.api.nvim_create_autocmd("FileType", {
	    group = "CocGroup",
	    pattern = "typescript,json",
	    command = "setl formatexpr=CocAction('formatSelected')",
	    desc = "Setup formatexpr specified filetype(s)."
	})

	-- Update signature help on jump placeholder
	vim.api.nvim_create_autocmd("User", {
	    group = "CocGroup",
	    pattern = "CocJumpPlaceholder",
	    command = "call CocActionAsync('showSignatureHelp')",
	    desc = "Update signature help on jump placeholder"
	})

	-- Apply codeAction to the selected region
	-- Example: `<leader>aap` for current paragraph
	local opts = {silent = true, nowait = true}
	keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
	keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

	-- Remap keys for apply code actions at the cursor position.
	keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
	-- Remap keys for apply code actions affect whole buffer.
	keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
	-- Remap keys for applying codeActions to the current buffer
	keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
	-- Apply the most preferred quickfix action on the current line.
	keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

	-- Remap keys for apply refactor code actions.
	keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
	keyset("n", "<C-t>", "<Plug>(coc-codeaction-refactor)", { silent = true })
	keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
	keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

	-- Run the Code Lens actions on the current line
	keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


	-- Map function and class text objects
	-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
	keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
	keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
	keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
	keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
	keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
	keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
	keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
	keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)


	-- Remap <C-f> and <C-b> to scroll float windows/popups
	---@diagnostic disable-next-line: redefined-local
	local opts = {silent = true, nowait = true, expr = true}
	keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
	keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
	keyset("i", "<C-f>",
	       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
	keyset("i", "<C-b>",
	       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
	keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
	keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


	-- Use CTRL-S for selections ranges
	-- Requires 'textDocument/selectionRange' support of language server
	keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
	keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})


	-- Add `:Format` command to format current buffer
	vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

	-- " Add `:Fold` command to fold current buffer
	vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

	-- Add `:OR` command for organize imports of the current buffer
	vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

	-- Mappings for CoCList
	-- code actions and coc stuff
	---@diagnostic disable-next-line: redefined-local
	local opts = {silent = true, nowait = true}
	-- Show commands
	keyset("n", "<space>aC", ":<C-u>CocList commands<cr>", opts)
	-- Find symbol of current document
	keyset("n", "<space>a~", ":<C-u>CocList outline<cr>", opts)
	-- Search workspace symbols
	keyset("n", "<space>as", ":<C-u>CocList -I symbols<cr>", opts)

	-- Show a lightbulb next to lines with an available code action
	vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]

	-- Other config to make things less horrible
	vim.opt.rnu = true
	
	-- Some servers have issues with backup files, see #649
	vim.opt.backup = false
	vim.opt.writebackup = false

	-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
	-- delays and poor user experience
	vim.opt.updatetime = 300

	-- Always show the signcolumn, otherwise it would shift the text each time
	-- diagnostics appeared/became resolved
	vim.opt.signcolumn = "yes"
end
