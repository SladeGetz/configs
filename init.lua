vim.api.nvim_command('set runtimepath^=~/.config/nvim/plugins')
vim.api.nvim_command('let &packpath = &runtimepath')

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.vim/plugged')

Plug 'dracula/vim'
-- Plug 'neovim/nvim-lspconfig'
-- Plug 'williamboman/nvim-lsp-installer'
-- Plug 'hrsh7th/nvim-cmp'
-- Plug 'hrsh7th/cmp-nvim-lsp'
-- Plug 'hrsh7th/vim-vsnip'
Plug 'tpope/vim-commentary'
Plug 'folke/neodev.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug ('neoclide/coc.nvim', {branch = 'release'})

vim.call('plug#end')

require("neodev")
require("lualine").setup()
-- require("coclsp")
-- require("nvim-cmp")
-- require("nvim-lsp-manager")
-- require('lspconfig')

vim.cmd([[
    filetype plugin on
    syntax enable
    colorscheme dracula

	set nobackup
	set nowritebackup
	
	set updatetime=300

	set signcolumn=yes

	inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
								  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	function! CheckBackspace() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction
]])

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.visualbell = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

function dump_table (object)
    if type(object) == "table" then
        local table_contents = ""
        for key, value in pairs(object) do
            table_contents = table_contents .. '"' .. key .. '": ' .. dump_table(value) .. "\n"
        end
        table_contents = table_contents:gsub("\n$", "")
        table_contents = table_contents:gsub("^(.+)", "    %1")
        table_contents = table_contents:gsub("\n", "\n    ")
        return "{\n" .. table_contents .. "\n}"
    elseif type(object) == "string" then
        return '"' .. object .. '"'
    else
        return tostring(object)
    end
end
