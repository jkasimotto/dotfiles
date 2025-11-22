local M = {}

local function on_attach(_, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  map("gd", vim.lsp.buf.definition, "Goto Definition")
  map("gr", vim.lsp.buf.references, "Goto References")
  map("gi", vim.lsp.buf.implementation, "Goto Implementation")
  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, "Format buffer")
end

local function capabilities()
  local base = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  if ok then
    return cmp.default_capabilities(base)
  end
  return base
end

local function build_server_config(name)
  local config = {
    on_attach = on_attach,
    capabilities = capabilities(),
  }

  if name == "lua_ls" then
    config.settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    }
  end

  return config
end

function M.setup()
  local lspconfig = require("lspconfig")
  local servers = {
    "lua_ls",
    "ts_ls",
    "pyright",
    "gopls",
    "bashls",
    "clangd",
  }

  require("mason").setup()
  require("mason-lspconfig").setup({ ensure_installed = servers })

  for _, server in ipairs(servers) do
    local def = lspconfig[server]
    if def and def.setup then
      def.setup(build_server_config(server))
    else
      vim.notify(("LSP server %s not found in lspconfig"):format(server), vim.log.levels.WARN)
    end
  end
end

return M
