# Dotfiles (zsh + Neovim)

Stow-friendly dotfiles to reuse on macOS and Raspberry Pi (Debian-based).

## Quick start
1) `git clone https://github.com/<you>/dotfiles.git ~/dotfiles`  
2) `cd ~/dotfiles`  
3) `stow zsh nvim`  
4) Start a new shell (`zsh`) and open `nvim` to let plugins install.

If `stow` reports conflicts, move the existing files out of the way first (e.g., `mv ~/.zshrc ~/.zshrc.bak`).

## Dependencies
- Core: `zsh`, `git`, `stow`, `neovim`, `ripgrep` (for Telescope live_grep).
- Optional but recommended for LSPs/treesitter: build tools (`build-essential` on Debian), `node`/`npm` (for TypeScript tools), `python3`, `go`, `clang`.

### macOS
```sh
brew install zsh neovim stow ripgrep git go python node
chsh -s "$(command -v zsh)"
```

### Raspberry Pi / Debian
```sh
sudo apt update
sudo apt install -y zsh neovim stow git ripgrep build-essential curl python3 nodejs npm golang clang
chsh -s "$(command -v zsh)"
```

## Notes
- Plugins are managed by **zgenom** (zsh) and **lazy.nvim** (Neovim). zgenom auto-installs to `~/.zgenom` on first load. Lazy installs to `~/.local/share/nvim`.
- Machine-specific or secret settings should live in `~/.zsh_local` (ignored by git). See `.zsh_local.example`.
- Neovim plugins are version-pinned via `lazy-lock.json`. Update with `:Lazy update` then commit the lockfile.
- Prompt uses Powerlevel10k; edit `~/.p10k.zsh` or run `p10k configure` to customize.
