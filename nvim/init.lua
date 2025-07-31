vim.api.nvim_command('set runtimepath^=~/.config/nvim')
-- vim.api.nvim_command('let &packpath = ~/.config/nvim/plugins')
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.vim/plugged')

Plug 'dracula/vim'

-- lsp stuffs
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'tpope/vim-commentary'
Plug 'folke/neodev.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'onsails/lspkind.nvim'
-- Plug ('neoclide/coc.nvim', {branch = 'release'})

-- follow latest release and install jsregexp.
Plug ('L3MON4D3/LuaSnip', {['tag'] = 'v2.*'})
-- Plug ('L3MON4D3/LuaSnip', {['do'] = { 'make install_jsregexp' } }) -- Replace <CurrentMajor> by the latest released major (first number of latest release)
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'tidalcycles/vim-tidal'

vim.call('plug#end')

-- require("lua-lsp")
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

]])

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.visualbell = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- function dump_table (object)
--     if type(object) == "table" then
--         local table_contents = ""
--         for key, value in pairs(object) do
--             table_contents = table_contents .. '"' .. key .. '": ' .. dump_table(value) .. "\n"
--         end
--         table_contents = table_contents:gsub("\n$", "")
--         table_contents = table_contents:gsub("^(.+)", "    %1")
--         table_contents = table_contents:gsub("\n", "\n    ")
--         return "{\n" .. table_contents .. "\n}"
--     elseif type(object) == "string" then
--         return '"' .. object .. '"'
--     else
--         return tostring(object)
--     end
-- end

-- lua <<EOF
  -- Set up nvim-cmp.
local lspkind = require('lspkind')
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.

  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show  symbol and text annotations
      -- maxwidth = {
      --   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      --   -- can also be a function to dynamically calculate max width such as
      --   -- menu = function() return math.floor(0.45 * vim.o.columns) end,
      --   menu = function() return math.floor(0.5 * vim.o.columns) end, -- leading text (labelDetails)
      --   abbr = function() return math.floor(0.5 * vim.o.columns) end, -- actual suggestion item
      -- },
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        -- ...
        return vim_item
      end
    })
    -- format = function(entry, vim_item)
    --     local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
    --     local strings = vim.split(kind.kind, "%s", { trimempty = true })
    --     kind.kind = " " .. (strings[1] or "") .. " "
    --     kind.menu = "    (" .. (strings[2] or "") .. ")"

    --     return kind
    -- end,
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    else
        fallback()
    end
  end),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    else
        fallback()
    end
  end),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  -- { name = 'vsnip' }, -- For vsnip users.
  { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- custom menu for diagnostics
vim.diagnostic.config({
    virtual_text = false
})

vim.o.updatetime = 50
vim.cmd [[ autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false}) ]]
-- cmp.setup({
--     view = {
--         entries = "custom"
--     }
-- })

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' },
}, {
  { name = 'buffer' },
})
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
}),
matching = { disallow_symbol_nonprefix_matching = false }
})

-- default lsps
vim.lsp.enable('bashls')
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['lua_ls'].setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields", "incomplete-signature-doc" }, --, "codestyle-check", "name-style-check" },
                unusedLocalExclude = { "_*" },
            },
        },
    },
    capabilities = capabilities
}
require('lspconfig')['bashls'].setup {
    capabilities = capabilities
}
