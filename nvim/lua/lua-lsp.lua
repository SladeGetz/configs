vim.lsp.config['lua_ls'] = {
     -- Command and arguments to start the server.
  cmd = { 'lua-language-server' },
  -- Filetypes to automatically attach to.
  filetypes = { 'lua' },
  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a
  -- ".luarc.jsonc" file. Files that share a root directory will reuse
  -- the connection to the same LSP server.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}
  -- on_init = function(client)
  --   if client.workspace_folders then
  --     local path = client.workspace_folders[1].name
  --     if
  --       path ~= vim.fn.stdpath('config')
  --       and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
  --     then
  --       return
  --     end
  --   end

  --   client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
  --     runtime = {
  --       -- Tell the language server which version of Lua you're using (most
  --       -- likely LuaJIT in the case of Neovim)
  --       version = 'LuaJIT',
  --       -- Tell the language server how to find Lua modules same way as Neovim
  --       -- (see `:h lua-module-load`)
  --       path = {
  --         'lua/?.lua',
  --         'lua/?/init.lua',
  --       },
  --     },
  --     -- Make the server aware of Neovim runtime files
  --     workspace = {
  --       checkThirdParty = false,
  --       library = {
  --         vim.env.VIMRUNTIME
  --         -- Depending on the usage, you might want to add additional paths
  --         -- here.
  --         -- '${3rd}/luv/library'
  --         -- '${3rd}/busted/library'
  --       }
  --       -- Or pull in all of 'runtimepath'.
  --       -- NOTE: this is a lot slower and will cause issues when working on
  --       -- your own configuration.
  --       -- See https://github.com/neovim/nvim-lspconfig/issues/3189
  --       -- library = {
  --       --   vim.api.nvim_get_runtime_file('', true),
  --       -- }
  --     }
  --   })
  -- end,
  -- settings = {
  --   Lua = {}
  -- }
-- })

vim.lsp.enable('lua_ls')
