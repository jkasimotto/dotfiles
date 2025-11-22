# NeoVim Configuration

Personal NeoVim configuration managed via Git. Clone or symlink this repository into `~/.config/nvim` on any machine to replicate the setup.

## Getting Started

```bash
# back up existing config if any
mv ~/.config/nvim ~/.config/nvim.backup

# clone this repo
git clone git@github.com:julianotto/nvim-config.git ~/Projects/nvim-config

# keep ~/.config/nvim pointing at the tracked files
ln -sf ~/Projects/nvim-config ~/.config/nvim

# open neovim; lazy.nvim will bootstrap itself and install plugins
nvim
```

## Included

- Lazy.nvim-based plugin manager with automatic bootstrap
- Visuals: Tokyonight colorscheme, Lualine statusline, devicons
- Productivity: Telescope, Treesitter, Comment.nvim, autopairs, Gitsigns
- LSP & completion: mason, mason-lspconfig, nvim-lspconfig (lua_ls, ts_ls, pyright, gopls, bashls, clangd), nvim-cmp, LuaSnip
- Sensible defaults, window navigation helpers, yank highlighting, markdown-friendly settings
