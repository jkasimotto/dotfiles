# Neovim Configuration

Managed as part of the stowable dotfiles. The symlink is created by running `stow nvim` from the repo root (`~/dotfiles`).

## Getting Started

```bash
cd ~/dotfiles
stow nvim
nvim  # lazy.nvim bootstraps itself and installs plugins
```

## Included

- Lazy.nvim-based plugin manager with automatic bootstrap
- Visuals: Tokyonight colorscheme, Lualine statusline, devicons
- Productivity: Telescope, Treesitter, Comment.nvim, autopairs, Gitsigns
- LSP & completion: mason, mason-lspconfig, nvim-lspconfig (lua_ls, ts_ls, pyright, gopls, bashls, clangd), nvim-cmp, LuaSnip
- Sensible defaults, window navigation helpers, yank highlighting, markdown-friendly settings
