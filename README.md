# dotfiles — macOS

Personal macOS configuration files organized by tool.

## Contents

| Directory | Tool | Config File(s) |
|-----------|------|----------------|
| `tmux/` | tmux | `.tmux.conf`, `.tmux-nowplaying` |
| `nvim/` | Neovim | LazyVim config |
| `zsh/` | Zsh + Oh My Zsh | `.zshrc`, `.zshenv`, custom themes/plugins |
| `ghostty/` | Ghostty | `config` |
| `karabiner/` | Karabiner-Elements | `karabiner.json` |
| `aerospace/` | Aerospace | `aerospace.toml` |
| `git/` | Git | `.gitconfig` |
| `starship/` | Starship | `starship.toml` |
| `kitty/` | Kitty | `kitty.conf` |
| `zed/` | Zed | `settings.json` |
| `bun/` | Bun/npm | `.npmrc` |
| `misc/` | Misc | `.bash_profile`, Raycast config |

## Usage

Symlink files to their expected locations:

```sh
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/nvim ~/.config/nvim
```
