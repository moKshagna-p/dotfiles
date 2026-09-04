# emacs — lean Purcell-inspired config

Minimal Emacs 30 config inspired by [purcell/emacs.d](https://github.com/purcell/emacs.d), curated from [emacs-tw/awesome-emacs](https://github.com/emacs-tw/awesome-emacs).

## Stack

- **Completion:** `vertico` + `orderless` + `marginalia` + `consult` + `embark` (Purcell's choice)
- **Auto-complete:** `corfu` + `cape` + `kind-icon` (Purcell)
- **Modal:** `evil` + `evil-collection` + `evil-surround` + `evil-nerd-commenter` + `general` (SPC leader)
- **LSP:** `eglot` + `flymake` (treesitter via `treesit-auto`)
- **Git/Project:** `magit` + `diff-hl` + `projectile` + `treemacs`
- **Theme:** `modus-themes` (built-in) + `solaire-mode`, `doom-modeline`
- **Navigation:** `avy`, `ace-window`, `pulsar`
- **Editing:** `smartparens`, `rainbow-delimiters`, `expand-region`, `multiple-cursors`, `ws-butler`, `crux`
- **Org:** `org-modern`

## Structure

```
configs/emacs/
  early-init.el  — perf + UI before startup (gc 128MB, no toolbars)
  init.el        — single-file config with use-package
  custom.el      — customize-generated vars (don't edit)
  lisp/init-local.el.example -> copy to init-local.el for personal overrides
```

## Install

```sh
# XDG location (Emacs 29+)
mkdir -p ~/.config
ln -sf ~/dotfiles/configs/emacs ~/.config/emacs

# Traditional fallback (optional)
ln -sf ~/dotfiles/configs/emacs ~/.emacs.d

# First launch will auto-install packages from MELPA
emacs
```

Packages install on first `M-x package-refresh-contents` if needed. Restart after first install.

## Keybindings

- `SPC` leader (Evil normal/visual/insert):
  - `SPC f f` find-file, `SPC b b` consult-buffer, `SPC s g` ripgrep
  - `SPC p p` projectile switch, `SPC g g` magit
  - `SPC w h/j/k/l` window nav, `SPC q q` quit
- `C-:` / `C-'` avy jump, `M-o` ace-window
- `C-=` expand-region, `C->` mc/mark-next
- `M-;` comment, `C-s` consult-line, `C-x g` magit

## Customization

Copy example and edit:

```sh
cp ~/dotfiles/configs/emacs/lisp/init-local.el.example ~/dotfiles/configs/emacs/lisp/init-local.el
```

That file is loaded at end of `init.el`.

Toggle theme: `<F5>` (modus-vivendi ↔ modus-operandi).
