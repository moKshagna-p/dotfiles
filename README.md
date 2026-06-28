# dotfiles — macOS

Personal macOS configuration files organized by tool.

## Contents

| Directory | Tool | Config File(s) |
|-----------|------|----------------|
| `configs/tmux/` | tmux | `.tmux.conf`, `.tmux-nowplaying` |
| `configs/nvim/` | Neovim | LazyVim config |
| `configs/zsh/` | Zsh + Oh My Zsh | `.zshrc`, `.zshenv`, custom themes/plugins |
| `configs/ghostty/` | Ghostty | `config` |
| `configs/karabiner/` | Karabiner-Elements | `karabiner.json` |
| `configs/aerospace/` | Aerospace | `aerospace.toml` |
| `configs/git/` | Git | `.gitconfig` |
| `configs/starship/` | Starship | `starship.toml` |
| `configs/kitty/` | Kitty | `kitty.conf` |
| `configs/zed/` | Zed | `settings.json` |
| `configs/misc/` | Misc | `.bash_profile`, Raycast config |

## Usage

Make changes inside `configs/` and copy files to their actual locations, or symlink:

```sh
ln -sf ~/dotfiles/configs/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/configs/nvim ~/.config/nvim
```
