local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'ge', vim.diagnostic.open_float, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup {
	on_attach = on_attach,
	flags = lsp_flags,

	settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            }
        }
    }
}
require('lspconfig')['pylsp'].setup {
	on_attach = on_attach,
	flags = lsp_flags,
}
require('lspconfig')['bashls'].setup {
	on_attach = on_attach,
	flags = lsp_flags,
}
require('lspconfig')['sumneko_lua'].setup {
	on_attach = on_attach,
	flags = lsp_flags,
}

local function is_string_in_list(str, list)
	for _, value in ipairs(list) do
		if str == value then
			return true
		end
	end
	return false
end

local function filter_diagnostics(diagnostics)
	local ignored_codes = {
		"undefined-global",
		"lowercase-global"
	}
	local new_diagnostics = {}
	for key, value in pairs(diagnostics) do
		local code = value["code"]
		local msg = value["message"]
		if not is_string_in_list(code, ignored_codes) then
			table.insert(new_diagnostics, value)
		elseif msg:match("Cannot access member") == nil then
			table.insert(new_diagnostics, value)
		end
	end
	return new_diagnostics
end

local og_diagnostics_set = vim.diagnostic.set
vim.diagnostic.set = function(ns, bufnr, og_diags, opts)
	diagnostics = filter_diagnostics(og_diags)
	og_diagnostics_set(ns, bufnr, diagnostics, opts)
end

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = false
})
